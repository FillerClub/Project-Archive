update_lobby();

while steam_net_packet_receive() {
	var player1 = steam_lobby_get_data("Player1"),
    player2 = steam_lobby_get_data("Player2"),
    playerID = obj_preasync_handler.steam_id,
    player1Ready = steam_lobby_get_data("Player1Ready"),
    player2Ready = steam_lobby_get_data("Player2Ready"),
	verbose = global.verbose_debug;
	steam_net_packet_get_data(inbuf);
	var SenderID = steam_net_packet_get_sender_id();
	if (buffer_get_size(inbuf) > 0) {
		buffer_seek(inbuf, buffer_seek_start, 0);
		var json = buffer_read(inbuf, buffer_text);
		var msg = json_parse(json);
		if struct_exists(msg,"Message") {
			switch(msg.Message) {
				case SEND.PLAYERJOIN:
					var userID = msg.Player,
					userHero = msg.PlayerHero,
					userLoadout = msg.PlayerLoadout;
					if player1 == 0 {
						steam_lobby_set_data("Player1",userID);		
						steam_lobby_set_data("Player1Hero",userHero);		
						steam_lobby_set_data("Player1Loadout",userLoadout);	
					} else if player2 == 0 {
						steam_lobby_set_data("Player2",userID);		
						steam_lobby_set_data("Player2Hero",userHero);		
						steam_lobby_set_data("Player2Loadout",userLoadout);							
					}
				break;
				case SEND.MATCHDATA:
					var dataTypeAmount = array_length(LOBBYDATA);
					for (var i = 0; i < dataTypeAmount; i++) {
						if variable_struct_exists(msg,LOBBYDATA[i]) {
							var data = variable_struct_get(msg,LOBBYDATA[i]);
							steam_lobby_set_data(LOBBYDATA[i],data);
							// Enable updating of certain objects again
							switch LOBBYDATA[i] {
								case "Player1Hero":
									with obj_hero_display {
										if player == 1 {
											read = true;
										}
									}
								break;
								case "Player2Hero":
									with obj_hero_display {
										if player == 2 {
											read = true;
										}
									}								
								break;
								case "Player1Loadout":
									with obj_loadout_slot {
										if index = 0 && player == 1 {
											read = true;
											update = true;
										}
									}
								break;
								case "Player2Loadout":
									with obj_loadout_slot {
										if index = 0 && player == 2 {
											read = true;
											update = true;
										}
									}
								break;
							}
						}
					}
				break;
				case SEND.GAMEDATA:
					if is_host {
						if verbose {
					        show_debug_message("Received action from player: " +msg.action_type);
					    }
						buffer_action(msg);
					} else {
						if verbose {
							show_debug_message("Received action unable to process: " +msg.action_type +" (How are you getting this?)");	
						}
					}
				break;
				case SEND.TICK_RESULTS:
					if !is_host {
					    if verbose {
					        show_debug_message("Received " + string(array_length(msg.actions)) + " results from host");
					    }
						with obj_battle_handler {
						    // Execute each action on client
						    for (var i = 0; i < array_length(msg.actions); i++) {
						        var action = msg.actions[i],
								hadPrediction = false;
								if variable_struct_exists(action,"prediction_id") {
									var prediction_id = action.prediction_id;
									hadPrediction = ds_map_exists(prediction_history, prediction_id);									
								}

								
								if hadPrediction {
						            verify_prediction(action);
						        } else if action.result == "success" {
									// This is opponent's action, execute it
								    array_push(other.requests,action);
								}
							}					
						}	
					}
				break;
				case SEND.INSERTTAG:
					object_tag_list = array_concat(object_tag_list,msg.tags);
				break;
				case SEND.READY:
					var rGo = rm_level_normal;
					switch obj_map_switch.map {
						case 1: rGo = rm_level_normal; break;
						case 2: rGo = rm_level_small; break;
						case 3: rGo = rm_level_split; break;
						case 4: rGo = rm_level_conveyor; break;
						case 5: rGo = rm_level_heights; break;
					}
					switch member_status {
						case MEMBERSTATUS.PLAYER1:
							global.player_team = "friendly";
							global.opponent_team = "enemy";				
						break;
						case MEMBERSTATUS.PLAYER2:
							global.player_team = "enemy";
							global.opponent_team = "friendly";				
						break;
						default:
							global.player_team = "nothing";
							global.opponent_team = "nothing";
						break;
					}
					with obj_hero_display {
						if (player == 1 && player1 == obj_preasync_handler.steam_id) || (player == 2 && player2 == obj_preasync_handler.steam_id) {
							global.active_hero = identity;
						} else {
							global.opponent_hero = identity;
						}
					}
					var arrayLength = global.max_slots;
					var playerLoadout = array_create(arrayLength,0);
					var opponentLoadout = array_create(arrayLength,0);
					with obj_loadout_slot {
						if (player == 1 && player1 == obj_preasync_handler.steam_id) || (player == 2 && player2 == obj_preasync_handler.steam_id) {
							playerLoadout[index] = identity;
						} else {
							opponentLoadout[index] = identity;
						}
					}
					
					global.max_turns = 6;
					global.friendly_turns = 4;
					global.enemy_turns = 4;
					global.loadout = playerLoadout;
					global.opponent_loadout = opponentLoadout;
					object_tag_list = msg.random_object_tags;
					if is_host {
						steam_lobby_set_data("Player1Ready",false);
						steam_lobby_set_data("Player2Ready",false);
					}
					in_level = true;
					room_goto(rGo);
				break;
			}
		}
	}	
}

if !in_level {
	exit;	
}

var tagLength = array_length(object_tag_list);
if tagLength < tag_list_length && !requested_tag {
	var tagRequest = {
	    Message: SEND.REQUESTTAG,
	    amount: tag_list_length -tagLength,
	};
	steam_relay_data(tagRequest);
	requested_tag = true;
}
// Tick Processing
if is_host {
	tick_timer += delta_time*DELTA_TO_SECONDS;	
	if tick_timer >= 1/TICKRATE {
	    tick_timer -= 1/TICKRATE;
	    process_tick();
	}
}
with obj_battle_handler {
	read_requests(other.requests, true);
}