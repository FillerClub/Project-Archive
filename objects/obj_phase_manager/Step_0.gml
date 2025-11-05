// obj_phase_manager - Step Event

var delta = delta_time / 1000000;
phase_timer += delta;

// Update ready grace timers
for (var i = 0; i < 2; i++) {
    var slot = obj_player_roster.player_slots[i];
    if (slot.is_ready && slot.ready_grace_timer > 0) {
        slot.ready_grace_timer -= delta;
        if (slot.ready_grace_timer <= 0) {
            slot.ready_grace_timer = 0;
            // Lock in selections after grace period
        }
    }
}

// Check if both players ready (for phases that allow ready-advance)
if (obj_lobby_controller.is_host && ready_can_advance) {
    var p1 = obj_player_roster.player_slots[PLAYER_SLOT.PLAYER_1];
    var p2 = obj_player_roster.player_slots[PLAYER_SLOT.PLAYER_2];

    if (p1.is_occupied() && p2.is_occupied() && p1.is_ready && p2.is_ready) {
        // Both ready and past grace period
        if (p1.ready_grace_timer <= 0 && p2.ready_grace_timer <= 0) {
            advance_phase();
        }
    }
}

// Phase-specific logic
switch (current_phase) {
    case LOBBY_PHASE.SETUP:
        // Waiting for both players to be ready
        break;

    case LOBBY_PHASE.BANS:
        // Check if time limit exceeded
        if (phase_time_limit > 0 && phase_timer >= phase_time_limit) {
            if (obj_lobby_controller.is_host) {
                // Auto-commit bans for players who haven't selected
                force_commit_bans();
            }
        }
        break;

    case LOBBY_PHASE.LOADOUTS:
        // Check if time limit exceeded
        if (phase_time_limit > 0 && phase_timer >= phase_time_limit) {
            if (obj_lobby_controller.is_host) {
                // Auto-finalize loadouts
                advance_phase();
            }
        }
        break;

    case LOBBY_PHASE.TRANSITION:
        // Countdown to game start
        if (obj_lobby_controller.is_host && phase_timer >= phase_time_limit) {
            start_game();
        }
        break;
}
