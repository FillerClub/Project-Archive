// obj_phase_manager - Manages lobby phases with ready-to-advance system

current_phase = LOBBY_PHASE.SETUP;
previous_phase = LOBBY_PHASE.SETUP;

// Phase timer
phase_timer = 0;
phase_time_limit = -1;      // -1 = no limit

// Ban phase data
ban_round = 0;              // Current ban round (0, 1, 2, etc.)
total_ban_rounds = 0;       // Total rounds based on max_slots
both_players_banned = false; // Both players committed current ban

// Ready system
ready_can_advance = true;   // Can ready advance this phase?

// Transition to new phase
function transition_to_phase(_new_phase) {
    if (!obj_lobby_controller.is_host) return;

    previous_phase = current_phase;
    current_phase = _new_phase;
    phase_timer = 0;

    // Reset ready states
    obj_player_roster.player_slots[PLAYER_SLOT.PLAYER_1].is_ready = false;
    obj_player_roster.player_slots[PLAYER_SLOT.PLAYER_2].is_ready = false;
    obj_player_roster.player_slots[PLAYER_SLOT.PLAYER_1].ready_grace_timer = 0;
    obj_player_roster.player_slots[PLAYER_SLOT.PLAYER_2].ready_grace_timer = 0;

    // Configure phase
    switch (current_phase) {
        case LOBBY_PHASE.SETUP:
            phase_time_limit = -1;
            ready_can_advance = true;
            break;

        case LOBBY_PHASE.BANS:
            // Calculate number of bans based on max_slots
            var max_slots = obj_lobby_settings.settings.max_slots;
            total_ban_rounds = floor(max_slots / 3);
            ban_round = 0;
            both_players_banned = false;
            phase_time_limit = PHASE_TIME_BANS_PER_ROUND;
            ready_can_advance = false;  // Can't ready-advance ban phase

            // Clear previous bans
            obj_player_roster.player_slots[PLAYER_SLOT.PLAYER_1].committed_bans = [];
            obj_player_roster.player_slots[PLAYER_SLOT.PLAYER_2].committed_bans = [];
            obj_player_roster.player_slots[PLAYER_SLOT.PLAYER_1].current_ban_selection = -1;
            obj_player_roster.player_slots[PLAYER_SLOT.PLAYER_2].current_ban_selection = -1;

            show_debug_message("Ban phase started. Total rounds: " + string(total_ban_rounds));
            break;

        case LOBBY_PHASE.LOADOUTS:
            phase_time_limit = PHASE_TIME_LOADOUTS;
            ready_can_advance = true;
            break;

        case LOBBY_PHASE.TRANSITION:
            phase_time_limit = PHASE_TIME_TRANSITION;
            ready_can_advance = false;  // Can't ready during transition
            break;

        case LOBBY_PHASE.IN_GAME:
            phase_time_limit = -1;
            ready_can_advance = false;
            break;
    }

    // Broadcast phase change
    steam_bounce({
        Message: SEND.PHASE_CHANGE,
        phase: current_phase,
        phase_timer: phase_timer,
        phase_time_limit: phase_time_limit,
        ban_round: ban_round,
        total_ban_rounds: total_ban_rounds
    });

    show_debug_message("Phase transition: " + get_phase_name(previous_phase) +
                      " -> " + get_phase_name(current_phase));
}

// HOST ONLY: Advance to next phase
function advance_phase() {
    if (!obj_lobby_controller.is_host) return;

    switch (current_phase) {
        case LOBBY_PHASE.SETUP:
            // Lock heroes after setup
            var p1 = obj_player_roster.player_slots[PLAYER_SLOT.PLAYER_1];
            var p2 = obj_player_roster.player_slots[PLAYER_SLOT.PLAYER_2];

            // Validate both have selected heroes
            if (p1.selected_hero == -1 || p2.selected_hero == -1) {
                show_debug_message("Both players must select heroes before advancing!");
                return;
            }

            // Check if bans enabled
            if (obj_lobby_settings.settings.enable_bans) {
                transition_to_phase(LOBBY_PHASE.BANS);
            } else {
                transition_to_phase(LOBBY_PHASE.LOADOUTS);
            }
            break;

        case LOBBY_PHASE.BANS:
            // This is handled by ban system (next_ban_round)
            break;

        case LOBBY_PHASE.LOADOUTS:
            transition_to_phase(LOBBY_PHASE.TRANSITION);
            break;

        case LOBBY_PHASE.TRANSITION:
            // Handled by start_game()
            break;
    }
}

// Toggle ready for my slot
function toggle_ready() {
    var my_slot = obj_player_roster.get_my_slot();
    if (my_slot == undefined) return;

    // Can't ready in transition phase
    if (current_phase == LOBBY_PHASE.TRANSITION) return;

    // Can only active players ready
    if (my_slot.slot_type != PLAYER_SLOT.PLAYER_1 &&
        my_slot.slot_type != PLAYER_SLOT.PLAYER_2) return;

    // Toggle ready state
    my_slot.is_ready = !my_slot.is_ready;

    if (my_slot.is_ready) {
        // Start grace period
        my_slot.ready_grace_timer = READY_GRACE_PERIOD;
    } else {
        // Unready
        my_slot.ready_grace_timer = 0;
    }

    // Send to host
    if (!obj_lobby_controller.is_host) {
        steam_relay_data({
            Message: SEND.READY_TOGGLE,
            is_ready: my_slot.is_ready
        });
    } else {
        // Host: broadcast to all
        obj_player_roster.sync_roster();
    }
}

// HOST ONLY: Force commit bans (timeout)
function force_commit_bans() {
    var p1 = obj_player_roster.player_slots[PLAYER_SLOT.PLAYER_1];
    var p2 = obj_player_roster.player_slots[PLAYER_SLOT.PLAYER_2];

    // Auto-commit with current selections (or -1 if none)
    if (array_length(p1.committed_bans) <= ban_round) {
        array_push(p1.committed_bans, p1.current_ban_selection);
    }
    if (array_length(p2.committed_bans) <= ban_round) {
        array_push(p2.committed_bans, p2.current_ban_selection);
    }

    // Move to next round
    next_ban_round();
}

// HOST ONLY: Move to next ban round (or end bans)
function next_ban_round() {
    if (!obj_lobby_controller.is_host) return;

    ban_round++;

    if (ban_round >= total_ban_rounds) {
        // Bans complete, move to loadouts
        transition_to_phase(LOBBY_PHASE.LOADOUTS);
    } else {
        // Next ban round
        phase_timer = 0;
        both_players_banned = false;

        // Reset current selections
        obj_player_roster.player_slots[PLAYER_SLOT.PLAYER_1].current_ban_selection = -1;
        obj_player_roster.player_slots[PLAYER_SLOT.PLAYER_2].current_ban_selection = -1;

        // Broadcast next round
        steam_bounce({
            Message: SEND.BAN_NEXT_ROUND,
            ban_round: ban_round,
            phase_timer: 0
        });
    }
}

// HOST ONLY: Receive ban commit from player
function receive_ban_commit(_steam_id, _piece_id) {
    if (!obj_lobby_controller.is_host) return;
    if (current_phase != LOBBY_PHASE.BANS) return;

    var slot = obj_player_roster.get_slot_by_id(_steam_id);
    if (slot == undefined) return;

    // Check if already committed this round
    if (array_length(slot.committed_bans) > ban_round) return;

    // Commit ban
    array_push(slot.committed_bans, _piece_id);
    slot.current_ban_selection = -1;

    // Check if both players committed
    var p1 = obj_player_roster.player_slots[PLAYER_SLOT.PLAYER_1];
    var p2 = obj_player_roster.player_slots[PLAYER_SLOT.PLAYER_2];

    if (array_length(p1.committed_bans) > ban_round &&
        array_length(p2.committed_bans) > ban_round) {
        // Both committed, reveal and move to next round
        reveal_bans_and_advance();
    }
}

// HOST ONLY: Reveal bans and advance to next round
function reveal_bans_and_advance() {
    var p1 = obj_player_roster.player_slots[PLAYER_SLOT.PLAYER_1];
    var p2 = obj_player_roster.player_slots[PLAYER_SLOT.PLAYER_2];

    var p1_ban = p1.committed_bans[ban_round];
    var p2_ban = p2.committed_bans[ban_round];

    // Broadcast reveal
    steam_bounce({
        Message: SEND.BAN_REVEAL,
        ban_round: ban_round,
        p1_ban: p1_ban,
        p2_ban: p2_ban
    });

    // Wait a moment then advance (could use a small timer)
    // For now, advance immediately
    next_ban_round();
}

// Start game
function start_game() {
    if (!obj_lobby_controller.is_host) return;

    transition_to_phase(LOBBY_PHASE.IN_GAME);

    // Generate seed and object tags
    randomise();
    var seed = random_get_seed();
    var tags = generate_tag_list(16);

    // Broadcast game start
    steam_bounce({
        Message: SEND.READY,
        level_seed: seed,
        random_object_tags: tags
    });

    // Host also starts
    obj_lobby_controller.start_game_client(seed, tags);
}

// Generate random object tags (for deterministic gameplay)
function generate_tag_list(_count) {
    var tags = [];
    for (var i = 0; i < _count; i++) {
        array_push(tags, irandom(999999));
    }
    return tags;
}

// CLIENT: Receive phase change from host
function receive_phase_change(_msg) {
    previous_phase = current_phase;
    current_phase = _msg.phase;
    phase_timer = _msg.phase_timer;
    phase_time_limit = _msg.phase_time_limit;

    if (variable_struct_exists(_msg, "ban_round")) {
        ban_round = _msg.ban_round;
        total_ban_rounds = _msg.total_ban_rounds;
    }
}

// Get phase name for UI
function get_phase_name(_phase = current_phase) {
    switch (_phase) {
        case LOBBY_PHASE.SETUP: return "Setup";
        case LOBBY_PHASE.BANS: return "Bans";
        case LOBBY_PHASE.LOADOUTS: return "Loadouts";
        case LOBBY_PHASE.TRANSITION: return "Starting...";
        case LOBBY_PHASE.IN_GAME: return "In Game";
        default: return "Unknown";
    }
}

// Get time remaining in phase
function get_time_remaining() {
    if (phase_time_limit <= 0) return -1;
    return max(0, phase_time_limit - phase_timer);
}
