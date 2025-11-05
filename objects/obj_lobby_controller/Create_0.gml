// obj_lobby_controller - Central lobby coordinator
// Replaces obj_client_manager with modular architecture

// Ensure singleton
if (instance_number(obj_lobby_controller) > 1) {
    instance_destroy();
    exit;
}

// === COMPATIBILITY VARIABLES (same as obj_client_manager) ===
is_host = false;
in_level = false;
current_tick = 0;
action_buffer = ds_map_create();
action_history = [];
object_tag_list = [];

// Member status (for backwards compatibility with existing code)
member_status = MEMBERSTATUS.SPECTATOR;

// Lobby data array (for backwards compatibility)
lobby_data = array_create(array_length(LOBBYDATA), "");

// === NEW MODULAR COMPONENTS ===
// These are NOT created here - they're created in room or by initialize()
// Just store references
player_roster = noone;
lobby_settings = noone;
phase_manager = noone;
chat_system = noone;

// Initialize function (called from room creation code)
function initialize() {
    // Create sub-managers if they don't exist
    if (!instance_exists(obj_player_roster)) {
        player_roster = instance_create_depth(0, 0, 0, obj_player_roster);
    } else {
        player_roster = instance_find(obj_player_roster, 0);
    }

    if (!instance_exists(obj_lobby_settings)) {
        lobby_settings = instance_create_depth(0, 0, 0, obj_lobby_settings);
    } else {
        lobby_settings = instance_find(obj_lobby_settings, 0);
    }

    if (!instance_exists(obj_phase_manager)) {
        phase_manager = instance_create_depth(0, 0, 0, obj_phase_manager);
    } else {
        phase_manager = instance_find(obj_phase_manager, 0);
    }

    if (!instance_exists(obj_chat_system)) {
        chat_system = instance_create_depth(0, 0, 0, obj_chat_system);
    } else {
        chat_system = instance_find(obj_chat_system, 0);
    }

    // Determine if host
    is_host = steam_lobby_is_owner();

    if (is_host) {
        show_debug_message("Lobby Controller: HOST initialized");

        // Host setup
        lobby_settings.sync_all_settings();

        // Add self to roster
        player_roster.add_player(obj_preasync_handler.steam_id, obj_preasync_handler.steam_name);

    } else {
        show_debug_message("Lobby Controller: CLIENT initialized");

        // Client setup
        lobby_settings.load_settings_from_lobby();

        // Announce join
        steam_relay_data({
            Message: SEND.PLAYER_JOIN,
            steam_id: obj_preasync_handler.steam_id,
            display_name: obj_preasync_handler.steam_name
        });
    }

    // Update member status for compatibility
    update_member_status();
}

// Update member status (for backwards compatibility)
function update_member_status() {
    var my_slot = player_roster.get_my_slot();

    if (my_slot == undefined) {
        member_status = MEMBERSTATUS.SPECTATOR;
    } else {
        switch (my_slot.slot_type) {
            case PLAYER_SLOT.PLAYER_1:
                member_status = MEMBERSTATUS.PLAYER1;
                break;
            case PLAYER_SLOT.PLAYER_2:
                member_status = MEMBERSTATUS.PLAYER2;
                break;
            default:
                member_status = MEMBERSTATUS.SPECTATOR;
                break;
        }
    }
}

// Process incoming network message
function process_message(_msg) {
    if (!variable_struct_exists(_msg, "Message")) return;

    switch (_msg.Message) {
        // === PLAYER MANAGEMENT ===
        case SEND.PLAYER_JOIN:
            if (is_host) {
                player_roster.add_player(_msg.steam_id, _msg.display_name);

                // Send full lobby state to new player
                send_packet_to_client(_msg.steam_id, {
                    Message: SEND.LOBBY_STATE,
                    roster: json_parse(steam_lobby_get_data("Roster")),
                    phase: phase_manager.current_phase
                });
            }
            break;

        case SEND.PLAYER_LEAVE:
            if (is_host) {
                player_roster.remove_player(_msg.steam_id);
            }
            break;

        case SEND.ROSTER_UPDATE:
            if (!is_host) {
                player_roster.load_roster(_msg.roster);
                update_member_status();
            }
            break;

        case SEND.JOIN_QUEUE:
            if (is_host) {
                var slot = player_roster.get_slot_by_id(_msg.sender_id);
                if (slot != undefined) {
                    // Move to queue
                    player_roster.join_queue();
                }
            }
            break;

        case SEND.LEAVE_QUEUE:
            if (is_host) {
                player_roster.leave_queue();
            }
            break;

        // === SETTINGS ===
        case SEND.SETTINGS_UPDATE:
            if (!is_host) {
                lobby_settings.receive_setting_update(_msg.key, _msg.value);
            }
            break;

        // === PHASE MANAGEMENT ===
        case SEND.PHASE_CHANGE:
            if (!is_host) {
                phase_manager.receive_phase_change(_msg);
            }
            break;

        case SEND.READY_TOGGLE:
            var slot = player_roster.get_slot_by_id(_msg.sender_id);
            if (slot != undefined) {
                slot.is_ready = _msg.is_ready;
                if (slot.is_ready) {
                    slot.ready_grace_timer = READY_GRACE_PERIOD;
                } else {
                    slot.ready_grace_timer = 0;
                }

                if (is_host) {
                    player_roster.sync_roster();
                }
            }
            break;

        // === BAN PHASE ===
        case SEND.BAN_COMMIT:
            if (is_host) {
                phase_manager.receive_ban_commit(_msg.sender_id, _msg.piece_id);
            }
            break;

        case SEND.BAN_REVEAL:
            if (!is_host && instance_exists(obj_ban_ui)) {
                obj_ban_ui.receive_ban_reveal(_msg.ban_round, _msg.p1_ban, _msg.p2_ban);
            }
            break;

        case SEND.BAN_NEXT_ROUND:
            if (!is_host) {
                phase_manager.ban_round = _msg.ban_round;
                phase_manager.phase_timer = _msg.phase_timer;
            }
            break;

        // === CHAT ===
        case SEND.CHAT_MESSAGE:
            if (instance_exists(obj_chat_system)) {
                chat_system.receive_message(_msg.sender_name, _msg.text, _msg.timestamp);
            }
            break;

        // === GAME START ===
        case SEND.READY:
            start_game_client(_msg.level_seed, _msg.random_object_tags);
            break;

        case SEND.GAME_END:
            if (!is_host) {
                in_level = false;
                room_goto(rm_match_menu);
            }
            break;

        case SEND.LOBBY_STATE:
            // Receiving full lobby state on join
            if (!is_host) {
                if (variable_struct_exists(_msg, "roster")) {
                    player_roster.load_roster(_msg.roster);
                }
                if (variable_struct_exists(_msg, "phase")) {
                    phase_manager.receive_phase_change(_msg);
                }
                update_member_status();
            }
            break;

        // === IN-GAME (Existing gameplay networking) ===
        case SEND.GAMEDATA:
            if (in_level && is_host) {
                // Process game action (keep existing logic)
                // This would call your existing game action processing
            }
            break;

        case SEND.TICK_RESULTS:
            if (in_level && !is_host) {
                // Apply tick results (keep existing logic)
            }
            break;

        case SEND.INSERTTAG:
            if (!is_host) {
                // Receive object tags (keep existing logic)
                object_tag_list = _msg.tags;
            }
            break;
    }
}

// CLIENT: Start game
function start_game_client(_seed, _tags) {
    show_debug_message("Starting game with seed: " + string(_seed));

    random_set_seed(_seed);
    object_tag_list = _tags;

    // Apply settings to globals
    lobby_settings.apply_to_globals();

    // Get my slot
    var my_slot = player_roster.get_my_slot();
    if (my_slot == undefined) {
        show_debug_message("ERROR: My slot not found!");
        return;
    }

    // Set teams and heroes based on slot
    var p1 = player_roster.player_slots[PLAYER_SLOT.PLAYER_1];
    var p2 = player_roster.player_slots[PLAYER_SLOT.PLAYER_2];

    switch (my_slot.slot_type) {
        case PLAYER_SLOT.PLAYER_1:
            global.player_team = "friendly";
            global.opponent_team = "enemy";
            global.active_hero = p1.selected_hero;
            global.loadout = p1.selected_loadout;
            global.opponent_hero = p2.selected_hero;
            global.opponent_loadout = p2.selected_loadout;
            break;

        case PLAYER_SLOT.PLAYER_2:
            global.player_team = "enemy";
            global.opponent_team = "friendly";
            global.active_hero = p2.selected_hero;
            global.loadout = p2.selected_loadout;
            global.opponent_hero = p1.selected_hero;
            global.opponent_loadout = p1.selected_loadout;
            break;

        default:  // Spectator
            global.player_team = "nothing";
            global.opponent_team = "nothing";
            break;
    }

    global.max_turns = 6;
    global.friendly_turns = 4;
    global.enemy_turns = 4;

    in_level = true;
    room_goto(lobby_settings.get_map_room());
}

// HOST: End game and handle queue rotation
function end_game(_winner_slot = -1) {
    if (!is_host) return;

    show_debug_message("Game ended. Winner: " + string(_winner_slot));

    // Handle queue rotation
    var rotation_mode = lobby_settings.get_setting("queue_rotation");
    if (rotation_mode != QUEUE_ROTATION.PLAYERS_STAY) {
        player_roster.rotate_queue(rotation_mode);
    }

    // Reset phase
    phase_manager.transition_to_phase(LOBBY_PHASE.SETUP);

    // Broadcast game end
    steam_bounce({
        Message: SEND.GAME_END,
        winner_slot: _winner_slot
    });

    in_level = false;
    room_goto(rm_match_menu);
}
