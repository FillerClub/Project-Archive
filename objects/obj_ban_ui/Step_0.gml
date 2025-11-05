// obj_ban_ui - Step Event

if (!visible) exit;
if (!instance_exists(obj_phase_manager)) exit;
if (obj_phase_manager.current_phase != LOBBY_PHASE.BANS) {
    hide_ui();
    exit;
}

// Get my slot
var my_slot = obj_player_roster.get_my_slot();
if (my_slot == undefined) exit;

// Can only ban if I'm an active player
if (my_slot.slot_type != PLAYER_SLOT.PLAYER_1 &&
    my_slot.slot_type != PLAYER_SLOT.PLAYER_2) exit;

// Check if I've committed this round
var current_round = obj_phase_manager.ban_round;
committed = (array_length(my_slot.committed_bans) > current_round);

// Check if opponent committed
var opponent_slot_index = (my_slot.slot_type == PLAYER_SLOT.PLAYER_1) ?
                          PLAYER_SLOT.PLAYER_2 : PLAYER_SLOT.PLAYER_1;
var opponent_slot = obj_player_roster.player_slots[opponent_slot_index];
opponent_committed = (array_length(opponent_slot.committed_bans) > current_round);

// Handle input (if not committed)
if (!committed) {
    // Navigate selection
    var move_x = keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left);
    var move_y = keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up);

    if (move_x != 0 || move_y != 0) {
        var current_index = -1;
        for (var i = 0; i < array_length(available_pieces); i++) {
            if (available_pieces[i] == my_selection) {
                current_index = i;
                break;
            }
        }

        if (current_index == -1) current_index = 0;

        current_index += move_x + (move_y * grid_cols);
        current_index = clamp(current_index, 0, array_length(available_pieces) - 1);

        my_selection = available_pieces[current_index];
        my_slot.current_ban_selection = my_selection;
    }

    // Commit ban
    if (keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(vk_enter)) {
        if (my_selection != -1 && !is_already_banned(my_selection)) {
            commit_ban(my_selection);
        }
    }
}
