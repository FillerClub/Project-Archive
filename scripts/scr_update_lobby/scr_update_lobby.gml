// Constants
#macro READY_COUNTDOWN_TIME 2.5

// Main lobby update function
function update_lobby() {
    is_host = steam_lobby_is_owner();
	if status_change != is_host {
		status_change = is_host;
		if global.verbose_debug {
			show_debug_message("=== STATUS CHANGE ===");
			if is_host {
				show_debug_message("You are playing as a host.");
			} else {
				show_debug_message("You are playing as a client.");
			}
		}
	}
	if (room == rm_match_menu || room == rm_lobby) {	
	    in_level = false;
	}
	if steam_lobby_get_lobby_id() == 0 || room == rm_lobby {
        member_status = MEMBERSTATUS.SPECTATOR;
        return;
    }

    update_lobby_data();
    update_player_status();
    if (is_host) {
        handle_game_start();
    }
}

// Update lobby data and sync with global variables
function update_lobby_data() {
   var data = LOBBYDATA,
    datLeng = array_length(data),
    readData = "",
    dataType = "",
    dataData = "",
    upd = false,
    bothReady = false,
	invalid = false;
    for (var i = 0; i < datLeng; i++) {
        readData = steam_lobby_get_data(data[i]);
        if readData != lobby_data[i].data {
            dataType = data[i];    
            dataData = readData;
            lobby_data[i].type = dataType;
            lobby_data[i].data = dataData;
			if is_undefined(readData) || readData == "" {
				invalid = true;	
			}
        }
        // Update game values if needed
        if lobby_data[i].update && !invalid {
			upd = true;
            switch dataType {
                case "Max Slots":  global.max_slots = int64(readData);
                break;
                case "Enable Bans": global.enable_bans = bool(readData);
                break;
                case "Barrier Win Condition": global.barrier_criteria = int64(readData);
                break;
                case "Time Until Timer Upgrade": global.timeruplength = int64(readData);
                break;
                case "Max Pieces": global.max_pieces = int64(readData);
                break;
                case "Map": global.map = int64(readData);
                break;
            }
        }
        if upd {
            lobby_data[i].update = false;
            upd = false;
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
    var playerID = obj_preasync_handler.steam_id;
    
    if player1 == playerID {
        member_status = MEMBERSTATUS.PLAYER1;
    } else if player2 == playerID {
        member_status = MEMBERSTATUS.PLAYER2;
    } else {
		member_status = MEMBERSTATUS.SPECTATOR;
	}
}
function generate_tag_list(length,characters = 3) {
	var tags = [],
	compromised = false;
	for (var i = 0; i < 8; i++) {
		var precheck = string_random(characters);
		for (var ii = 0; ii < array_length(tags); ii++) {
			if tags[ii] == precheck {
				compromised = true;
				break;
			}
		}
		if compromised {
			break;	
		}
		array_push(tags,precheck);
	}
	if compromised {
		tags = generate_tag_list(length,characters);	
	}
	return tags;
}
// Handle game start logic (host only)
function handle_game_start() {
    var player1_ready = steam_lobby_get_data("Player1Ready");
    var player2_ready = steam_lobby_get_data("Player2Ready");

    if player1_ready != "" && player2_ready != "" && int64(player1_ready) && int64(player2_ready) {
		ready_timer += delta_time*DELTA_TO_SECONDS;
	} else {
		ready_timer = 0;	
	}
    if ready_timer >= READY_COUNTDOWN_TIME && !in_level {
        randomise();
		var seed = random_get_seed();
		var tags = generate_tag_list(tag_list_length);
		steam_bounce({Message: SEND.READY, level_seed: seed, random_object_tags: tags});
		ready_timer = 0;
    }
}