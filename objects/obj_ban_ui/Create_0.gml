// obj_ban_ui - Simultaneous blind ban UI

depth = -100;
visible = false;

// UI layout
ui_x = room_width / 2;
ui_y = room_height / 2;
grid_cols = 8;
grid_rows = 4;
cell_size = 64;
cell_padding = 8;

// Available pieces
available_pieces = [];

// My selection
my_selection = -1;
committed = false;

// Show opponent committed (but not their selection)
opponent_committed = false;

// Ban history (revealed bans)
ban_history = [];  // Array of {round, p1_ban, p2_ban}

// Commit my ban
function commit_ban(_piece_id) {
    var my_slot = obj_player_roster.get_my_slot();
    if (my_slot == undefined) return;

    // Send to host
    if (!obj_lobby_controller.is_host) {
        steam_relay_data({
            Message: SEND.BAN_COMMIT,
            piece_id: _piece_id
        });
    } else {
        // Host commits directly
        obj_phase_manager.receive_ban_commit(obj_preasync_handler.steam_id, _piece_id);
    }

    committed = true;
}

// Check if piece already banned
function is_already_banned(_piece_id) {
    for (var i = 0; i < array_length(ban_history); i++) {
        if (ban_history[i].p1_ban == _piece_id || ban_history[i].p2_ban == _piece_id) {
            return true;
        }
    }
    return false;
}

// Receive ban reveal from host
function receive_ban_reveal(_round, _p1_ban, _p2_ban) {
    array_push(ban_history, {
        round: _round,
        p1_ban: _p1_ban,
        p2_ban: _p2_ban
    });

    committed = false;
    opponent_committed = false;
    my_selection = -1;
}

// Show UI
function show_ui() {
    visible = true;
    load_available_pieces();
    ban_history = [];
    my_selection = -1;
    committed = false;
    opponent_committed = false;
}

// Hide UI
function hide_ui() {
    visible = false;
}

// Load available pieces from game data
function load_available_pieces() {
    available_pieces = [];

    // Get all pieces from EVERYTHING macro
    for (var i = 0; i < array_length(EVERYTHING); i++) {
        array_push(available_pieces, i);
    }
}
