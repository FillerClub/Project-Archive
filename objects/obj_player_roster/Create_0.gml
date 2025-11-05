// obj_player_roster - Manages player slots, queue, and spectators

// Player slot structure
function PlayerSlot(_steam_id = "", _slot_type = PLAYER_SLOT.PLAYER_1) constructor {
    steam_id = _steam_id;
    slot_type = _slot_type;
    display_name = "";
    is_ready = false;
    ready_grace_timer = 0;          // 1.5s grace period after readying

    // Selection data
    selected_hero = -1;
    selected_loadout = [];
    current_ban_selection = -1;     // Current ban being selected (not committed)
    committed_bans = [];            // Bans that have been committed

    static is_occupied = function() {
        return steam_id != "";
    }

    static clear = function() {
        steam_id = "";
        display_name = "";
        is_ready = false;
        ready_grace_timer = 0;
        selected_hero = -1;
        selected_loadout = [];
        current_ban_selection = -1;
        committed_bans = [];
    }

    static set_player = function(_steam_id, _display_name) {
        steam_id = _steam_id;
        display_name = _display_name;
    }
}

// Active player slots (only 2)
player_slots = [
    new PlayerSlot("", PLAYER_SLOT.PLAYER_1),
    new PlayerSlot("", PLAYER_SLOT.PLAYER_2)
];

// Queue system (players waiting to play)
player_queue = [];              // Array of PlayerSlot structs
queue_open = true;              // Host can close queue

// Spectator system (players just watching)
spectators = [];                // Array of PlayerSlot structs

// Get my slot (checks active slots, queue, and spectators)
function get_my_slot() {
    var my_steam_id = obj_preasync_handler.steam_id;

    // Check active player slots
    for (var i = 0; i < array_length(player_slots); i++) {
        if (player_slots[i].steam_id == my_steam_id) {
            return player_slots[i];
        }
    }

    // Check queue
    for (var i = 0; i < array_length(player_queue); i++) {
        if (player_queue[i].steam_id == my_steam_id) {
            return player_queue[i];
        }
    }

    // Check spectators
    for (var i = 0; i < array_length(spectators); i++) {
        if (spectators[i].steam_id == my_steam_id) {
            return spectators[i];
        }
    }

    return undefined;
}

// Get slot by Steam ID
function get_slot_by_id(_steam_id) {
    for (var i = 0; i < array_length(player_slots); i++) {
        if (player_slots[i].steam_id == _steam_id) {
            return player_slots[i];
        }
    }

    for (var i = 0; i < array_length(player_queue); i++) {
        if (player_queue[i].steam_id == _steam_id) {
            return player_queue[i];
        }
    }

    for (var i = 0; i < array_length(spectators); i++) {
        if (spectators[i].steam_id == _steam_id) {
            return spectators[i];
        }
    }

    return undefined;
}

// Add player to lobby (defaults to spectator)
function add_player(_steam_id, _display_name) {
    // Check if already in lobby
    if (get_slot_by_id(_steam_id) != undefined) {
        return get_slot_by_id(_steam_id);
    }

    // Try to fill empty player slot first
    for (var i = 0; i < array_length(player_slots); i++) {
        if (!player_slots[i].is_occupied()) {
            player_slots[i].set_player(_steam_id, _display_name);

            if (obj_lobby_controller.is_host) {
                sync_roster();
            }

            return player_slots[i];
        }
    }

    // Add to spectators if slots full
    var spec_slot = new PlayerSlot(_steam_id, PLAYER_SLOT.SPECTATOR);
    spec_slot.display_name = _display_name;
    array_push(spectators, spec_slot);

    if (obj_lobby_controller.is_host) {
        sync_roster();
    }

    return spec_slot;
}

// Remove player from lobby
function remove_player(_steam_id) {
    // Check player slots
    for (var i = 0; i < array_length(player_slots); i++) {
        if (player_slots[i].steam_id == _steam_id) {
            player_slots[i].clear();

            // Try to promote from queue if available
            if (array_length(player_queue) > 0) {
                var promoted = player_queue[0];
                player_slots[i].set_player(promoted.steam_id, promoted.display_name);
                array_delete(player_queue, 0, 1);
            }

            if (obj_lobby_controller.is_host) {
                sync_roster();
            }
            return;
        }
    }

    // Check queue
    for (var i = 0; i < array_length(player_queue); i++) {
        if (player_queue[i].steam_id == _steam_id) {
            array_delete(player_queue, i, 1);
            if (obj_lobby_controller.is_host) sync_roster();
            return;
        }
    }

    // Check spectators
    for (var i = 0; i < array_length(spectators); i++) {
        if (spectators[i].steam_id == _steam_id) {
            array_delete(spectators, i, 1);
            if (obj_lobby_controller.is_host) sync_roster();
            return;
        }
    }
}

// Join queue (opt-in)
function join_queue() {
    var my_steam_id = obj_preasync_handler.steam_id;
    var slot = get_slot_by_id(my_steam_id);

    if (slot == undefined) return false;

    // Can't join queue if already in active slots
    if (slot.slot_type == PLAYER_SLOT.PLAYER_1 || slot.slot_type == PLAYER_SLOT.PLAYER_2) {
        return false;
    }

    // Can't join if queue closed
    if (!queue_open) return false;

    // Already in queue?
    for (var i = 0; i < array_length(player_queue); i++) {
        if (player_queue[i].steam_id == my_steam_id) {
            return false;
        }
    }

    // Remove from spectators
    for (var i = 0; i < array_length(spectators); i++) {
        if (spectators[i].steam_id == my_steam_id) {
            array_delete(spectators, i, 1);
            break;
        }
    }

    // Add to queue
    var queue_slot = new PlayerSlot(my_steam_id, PLAYER_SLOT.SPECTATOR);
    queue_slot.display_name = slot.display_name;
    array_push(player_queue, queue_slot);

    // Send to host
    if (!obj_lobby_controller.is_host) {
        steam_relay_data({
            Message: SEND.JOIN_QUEUE
        });
    } else {
        sync_roster();
    }

    return true;
}

// Leave queue (opt-out, return to spectators)
function leave_queue() {
    var my_steam_id = obj_preasync_handler.steam_id;

    for (var i = 0; i < array_length(player_queue); i++) {
        if (player_queue[i].steam_id == my_steam_id) {
            var queue_slot = player_queue[i];
            array_delete(player_queue, i, 1);

            // Add to spectators
            var spec_slot = new PlayerSlot(my_steam_id, PLAYER_SLOT.SPECTATOR);
            spec_slot.display_name = queue_slot.display_name;
            array_push(spectators, spec_slot);

            // Send to host
            if (!obj_lobby_controller.is_host) {
                steam_relay_data({
                    Message: SEND.LEAVE_QUEUE
                });
            } else {
                sync_roster();
            }

            return true;
        }
    }

    return false;
}

// HOST ONLY: Set queue open/closed
function set_queue_open(_open) {
    if (!obj_lobby_controller.is_host) return;

    queue_open = _open;
    sync_roster();
}

// HOST ONLY: Manually assign player to slot
function assign_to_slot(_steam_id, _target_slot) {
    if (!obj_lobby_controller.is_host) return;
    if (_target_slot < 0 || _target_slot >= array_length(player_slots)) return;

    var source_slot = get_slot_by_id(_steam_id);
    if (source_slot == undefined) return;

    // If target slot occupied, swap
    if (player_slots[_target_slot].is_occupied()) {
        var displaced = player_slots[_target_slot];

        // Move displaced player based on source
        if (source_slot.slot_type == PLAYER_SLOT.PLAYER_1 ||
            source_slot.slot_type == PLAYER_SLOT.PLAYER_2) {
            // Swap positions
            var other_index = (source_slot.slot_type == PLAYER_SLOT.PLAYER_1) ? 0 : 1;
            player_slots[other_index].steam_id = displaced.steam_id;
            player_slots[other_index].display_name = displaced.display_name;
        } else {
            // Send displaced to queue or spectators
            var displaced_slot = new PlayerSlot(displaced.steam_id, PLAYER_SLOT.SPECTATOR);
            displaced_slot.display_name = displaced.display_name;
            array_push(player_queue, displaced_slot);
        }
    }

    // Assign to target slot
    player_slots[_target_slot].set_player(_steam_id, source_slot.display_name);

    // Remove from source
    if (source_slot.slot_type == PLAYER_SLOT.SPECTATOR) {
        // Remove from queue or spectators
        for (var i = 0; i < array_length(player_queue); i++) {
            if (player_queue[i].steam_id == _steam_id) {
                array_delete(player_queue, i, 1);
                break;
            }
        }
        for (var i = 0; i < array_length(spectators); i++) {
            if (spectators[i].steam_id == _steam_id) {
                array_delete(spectators, i, 1);
                break;
            }
        }
    }

    sync_roster();
}

// HOST ONLY: Rotate queue based on mode
function rotate_queue(_mode) {
    if (!obj_lobby_controller.is_host) return;
    if (array_length(player_queue) == 0) return;

    switch (_mode) {
        case QUEUE_ROTATION.LOSERS_MOVE:
            // Loser (P2) goes to back of queue, promote next from queue
            var loser = player_slots[PLAYER_SLOT.PLAYER_2];
            if (loser.is_occupied()) {
                var queue_slot = new PlayerSlot(loser.steam_id, PLAYER_SLOT.SPECTATOR);
                queue_slot.display_name = loser.display_name;
                array_push(player_queue, queue_slot);

                // Promote from queue
                loser.set_player(player_queue[0].steam_id, player_queue[0].display_name);
                array_delete(player_queue, 0, 1);
            }
            break;

        case QUEUE_ROTATION.WINNERS_MOVE:
            // Winner (P1) goes to back of queue
            var winner = player_slots[PLAYER_SLOT.PLAYER_1];
            if (winner.is_occupied()) {
                var queue_slot = new PlayerSlot(winner.steam_id, PLAYER_SLOT.SPECTATOR);
                queue_slot.display_name = winner.display_name;
                array_push(player_queue, queue_slot);

                // Promote from queue
                winner.set_player(player_queue[0].steam_id, player_queue[0].display_name);
                array_delete(player_queue, 0, 1);
            }
            break;

        case QUEUE_ROTATION.BOTH_MOVE:
            // Both players go to back, promote next 2
            if (array_length(player_queue) >= 2) {
                for (var i = 0; i < 2; i++) {
                    var current = player_slots[i];
                    if (current.is_occupied()) {
                        var queue_slot = new PlayerSlot(current.steam_id, PLAYER_SLOT.SPECTATOR);
                        queue_slot.display_name = current.display_name;
                        array_push(player_queue, queue_slot);

                        current.set_player(player_queue[0].steam_id, player_queue[0].display_name);
                        array_delete(player_queue, 0, 1);
                    }
                }
            }
            break;

        case QUEUE_ROTATION.PLAYERS_STAY:
        default:
            // Do nothing
            break;
    }

    sync_roster();
}

// HOST ONLY: Sync roster to all clients
function sync_roster() {
    if (!obj_lobby_controller.is_host) return;

    var roster_data = {
        player_slots: [],
        queue: [],
        spectators: [],
        queue_open: queue_open
    };

    // Serialize player slots
    for (var i = 0; i < array_length(player_slots); i++) {
        array_push(roster_data.player_slots, {
            steam_id: player_slots[i].steam_id,
            display_name: player_slots[i].display_name,
            is_ready: player_slots[i].is_ready
        });
    }

    // Serialize queue
    for (var i = 0; i < array_length(player_queue); i++) {
        array_push(roster_data.queue, {
            steam_id: player_queue[i].steam_id,
            display_name: player_queue[i].display_name
        });
    }

    // Serialize spectators
    for (var i = 0; i < array_length(spectators); i++) {
        array_push(roster_data.spectators, {
            steam_id: spectators[i].steam_id,
            display_name: spectators[i].display_name
        });
    }

    // Store in Steam lobby
    steam_lobby_set_data("Roster", json_stringify(roster_data));

    // Broadcast
    steam_bounce({
        Message: SEND.ROSTER_UPDATE,
        roster: roster_data
    });
}

// CLIENT: Load roster from network update
function load_roster(_roster_data) {
    // Clear current
    for (var i = 0; i < array_length(player_slots); i++) {
        player_slots[i].clear();
    }
    player_queue = [];
    spectators = [];

    // Load player slots
    for (var i = 0; i < array_length(_roster_data.player_slots); i++) {
        var data = _roster_data.player_slots[i];
        player_slots[i].set_player(data.steam_id, data.display_name);
        player_slots[i].is_ready = data.is_ready;
    }

    // Load queue
    for (var i = 0; i < array_length(_roster_data.queue); i++) {
        var data = _roster_data.queue[i];
        var queue_slot = new PlayerSlot(data.steam_id, PLAYER_SLOT.SPECTATOR);
        queue_slot.display_name = data.display_name;
        array_push(player_queue, queue_slot);
    }

    // Load spectators
    for (var i = 0; i < array_length(_roster_data.spectators); i++) {
        var data = _roster_data.spectators[i];
        var spec_slot = new PlayerSlot(data.steam_id, PLAYER_SLOT.SPECTATOR);
        spec_slot.display_name = data.display_name;
        array_push(spectators, spec_slot);
    }

    queue_open = _roster_data.queue_open;
}
