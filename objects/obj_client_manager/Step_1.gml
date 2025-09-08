update_lobby();

while (steam_net_packet_receive()) {
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
					userLoadout = msg.PlayerLoadout,
					player1 = steam_lobby_get_data("Player1"),
					player2 = steam_lobby_get_data("Player2");
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
					if member_status = MEMBERSTATUS.HOST {
						// HOST: Batch instead of immediate bounce
						batch_action_for_tick(msg);
					}
				break;
				case SEND.PROCESSED_TICK:
					handle_authoritative_actions(msg);
				break;
				case SEND.REQUEST_DETAILED_STATE:
				    handle_detailed_state_sync(msg);
				break;
				case SEND.PERIODIC_SYNC:
					handle_periodic_sync_packet(msg);
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
					steam_lobby_set_data("Player1Ready",false);
					steam_lobby_set_data("Player2Ready",false);
					global.max_turns = 6;
					global.friendly_turns = 4;
					global.enemy_turns = 4;
					global.loadout = playerLoadout;
					global.opponent_loadout = opponentLoadout;
					room_goto(rGo);
				break;
			}
		}
	}	
}

if in_level && is_host {
	tick_timer += delta_time*DELTA_TO_SECONDS;	
	if tick_timer >= 1/TICKLENGTH {
		tick_timer -= 1/TICKLENGTH;
		tick_count++;
		process_completed_tick_batches();
		handle_periodic_sync();
	}	
}