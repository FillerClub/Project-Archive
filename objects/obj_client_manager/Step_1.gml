if steam_lobby_get_lobby_id() != 0 && room != rm_lobby {
	var data = LOBBYDATA,
	datLeng = array_length(data),
	readData = "",
	dataType = "",
	dataData = "",
	upd = false,
	bothReady = false;
	for (var i = 0; i < datLeng; i++) {
		readData = steam_lobby_get_data(data[i]);
		if readData != lobby_data[i].data {
			dataType = data[i];	
			dataData = is_undefined(readData)?"Undefined":readData;
			lobby_data[i].type = dataType;
			lobby_data[i].data = dataData;
			upd = true;
		}
		// Update game values if needed
		if lobby_data[i].update {
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
	var player1 = steam_lobby_get_data("Player1"),
	player2 = steam_lobby_get_data("Player2"),
	playerID = obj_preasync_handler.steam_id,
	player1Ready = steam_lobby_get_data("Player1Ready"),
	player2Ready = steam_lobby_get_data("Player2Ready");
	if steam_lobby_is_owner() {
		member_status = MEMBERSTATUS.HOST;	
	} else if player1 == playerID || player2 == playerID {
		member_status = MEMBERSTATUS.MEMBER;	
	} else {
		member_status = MEMBERSTATUS.SPECTATOR;	
	}
	if player1Ready != "" && player2Ready != "" && member_status == MEMBERSTATUS.HOST {
		if int64(player1Ready) && int64(player2Ready) {
			ready_timer	+= delta_time*DELTA_TO_SECONDS;
		} else {
			ready_timer = 0;
			in_level = false;
		}
		if ready_timer >= 3 && !in_level {
			randomise();
			var seed = random_get_seed();
			steam_bounce({Message: SEND.READY, level_seed: seed});
			in_level = true;
		}
	}
} else {
	member_status = MEMBERSTATUS.SPECTATOR;	
}

while (steam_net_packet_receive()) {
	steam_net_packet_get_data(inbuf);
	var SenderID = steam_net_packet_get_sender_id();
	if (buffer_get_size(inbuf) > 0) {
		buffer_seek(inbuf, buffer_seek_start, 0);
		var json = buffer_read(inbuf, buffer_text);
		var msg = json_parse(json);
		if struct_exists(msg,"Message") {
			switch(msg.Message) {
				case SEND.CONNECT:
					var isMe = buffer_read(buffer_c,buffer_bool),
					iD = buffer_read(buffer_c,buffer_string);
					// Grab port number for future reference
					if isMe {
						connection_status = true;
						network_id = iD;
						var lD = {
							run: "Lobby",
							rm: rm_lobby,
							load: [standalone_soundtracks]
						}
						start_transition(sq_circle_out,sq_circle_in,lD);
					} else {
						var	dataInsert = new create_player_data(-1,iD,-1,-1,-1,-1,noone,noone);
						array_push(players,dataInsert);
					}
				break;
				case SEND.PING:
					with obj_ping {
						ping_send = true;	
					}
				break;
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
					array_push(requests,msg);
				break;
				case SEND.DISCONNECT:
					var isMe = buffer_read(buffer_c,buffer_bool),
					iD = buffer_read(buffer_c,buffer_string);
					arLeng = array_length(players);
					if !isMe {
						for (var d = 0; d < arLeng; d++) {
							if players[d].network_id == iD {
								array_delete(players,d,1);	
								break;
							}
						}
						update_players = true;	
					}
				break;
				case SEND.TOGGLEJOIN:
					var iDIn = buffer_read(buffer_c,buffer_string);
					if iDIn == opponent_id {
						opponent_id = -1;
						// Temporary block of code
						switch game_status {
							case ONLINESTATUS.PREPARING:
								game_status = ONLINESTATUS.WAITING;
								buffer_seek(send_buffer,buffer_seek_start,0);
								buffer_write(send_buffer,buffer_u8,SEND.MATCHDATA);
								write_data_buffer(send_buffer,DATA.STATUS,game_status);
								buffer_write(send_buffer,buffer_u8,DATA.END);
								network_send_udp(socket,server_ip,server_port,send_buffer,buffer_tell(send_buffer));
								if member_status == MEMBERSTATUS.MEMBER {
									if room == rm_match_menu { shift_hero_displays(); }
									member_status = MEMBERSTATUS.HOST;
									create_system_message(["Host of current match has left, you are now host."])
								}
							break;
							case ONLINESTATUS.INGAME:
								instance_destroy(obj_client_manager);
								create_system_message(["Opponent has disconnected."]);
								room_goto(rm_main_menu);
							break;
						}
					} else {
						opponent_id = iDIn;
					}
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
						case MEMBERSTATUS.HOST:
							global.player_team = "friendly";
							global.opponent_team = "enemy";				
						break;
						case MEMBERSTATUS.MEMBER:
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