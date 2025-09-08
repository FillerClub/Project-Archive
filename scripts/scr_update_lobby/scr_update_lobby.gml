// Constants
#macro READY_COUNTDOWN_TIME 3

// Main lobby update function
function update_lobby() {
    is_host = steam_lobby_is_owner();
    
    if (!is_in_valid_lobby()) {
        member_status = MEMBERSTATUS.SPECTATOR;
        return;
    }
    
    update_lobby_data();
    update_player_status();
    
    if (is_host) {
        handle_game_start();
    }
}

// Check if we're in a valid lobby
function is_in_valid_lobby() {
    return steam_lobby_get_lobby_id() != 0 && room != rm_lobby;
}

// Update lobby data and sync with global variables
function update_lobby_data() {
    var data = LOBBYDATA;
    var data_length = array_length(data);
    
    for (var i = 0; i < data_length; i++) {
        var current_data = steam_lobby_get_data(data[i]);
        
        if (has_data_changed(i, current_data)) {
            update_lobby_data_entry(i, data[i], current_data);
            sync_global_variable(data[i], current_data);
        }
    }
}

// Check if lobby data has changed
function has_data_changed(index, new_data) {
    var safe_data = is_undefined(new_data) ? "Undefined" : new_data;
    return safe_data != lobby_data[index].data;
}

// Update a single lobby data entry
function update_lobby_data_entry(index, data_type, new_data) {
    var safe_data = is_undefined(new_data) ? "Undefined" : new_data;
    
    lobby_data[index].type = data_type;
    lobby_data[index].data = safe_data;
    lobby_data[index].update = false;
}

// Sync lobby data with global variables
function sync_global_variable(data_type, data_value) {
    if (is_undefined(data_value)) return;
    
    switch (data_type) {
        case "Max Slots":
            global.max_slots = int64(data_value);
            break;
            
        case "Enable Bans":
            global.enable_bans = bool(data_value);
            break;
            
        case "Barrier Win Condition":
            global.barrier_criteria = int64(data_value);
            break;
            
        case "Time Until Timer Upgrade":
            global.timeruplength = int64(data_value);
            break;
            
        case "Max Pieces":
            global.max_pieces = int64(data_value);
            break;
            
        case "Map":
            global.map = int64(data_value);
            break;
    }
}

// Update player status (member or spectator)
function update_player_status() {
    var player1 = steam_lobby_get_data("Player1");
    var player2 = steam_lobby_get_data("Player2");
    var player_id = obj_preasync_handler.steam_id;
    
    if (player1 == player_id || player2 == player_id) {
        member_status = MEMBERSTATUS.MEMBER;
    } else {
        member_status = MEMBERSTATUS.SPECTATOR;
    }
}

// Handle game start logic (host only)
function handle_game_start() {
    var player1_ready = steam_lobby_get_data("Player1Ready");
    var player2_ready = steam_lobby_get_data("Player2Ready");
    
    if (!are_both_players_ready(player1_ready, player2_ready)) {
        reset_ready_timer();
        return;
    }
    
    update_ready_timer();
    
    if (should_start_game()) {
        start_multiplayer_game();
    }
}

// Check if both players are ready
function are_both_players_ready(player1_ready, player2_ready) {
    return player1_ready != "" && player2_ready != "" && 
           int64(player1_ready) && int64(player2_ready);
}

// Reset ready timer if not in appropriate room
function reset_ready_timer() {
    if (room == rm_loadout_zone_multiplayer || room == rm_lobby) {
        ready_timer = 0;
        in_level = false;
    }
}

// Update the countdown timer
function update_ready_timer() {
    ready_timer += delta_time * DELTA_TO_SECONDS;
}

// Check if game should start
function should_start_game() {
    return ready_timer >= READY_COUNTDOWN_TIME && !in_level;
}

// Start the multiplayer game
function start_multiplayer_game() {
    randomise();
    var seed = random_get_seed();
    steam_bounce({Message: SEND.READY, level_seed: seed});
    in_level = true;
}