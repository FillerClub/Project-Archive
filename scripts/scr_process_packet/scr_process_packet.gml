function process_packet_server(buffer_s){
	// SERVER
	var 
	port = async_load[? "port"],
	ip = string(async_load[? "ip"]),
	valid = false,
	ID = buffer_read(buffer_s,buffer_u8),
	arLeng = array_length(players);
	show_message(port);
	switch ID {
		case SEND.CONNECT:
			var 
			name = buffer_read(buffer_s,buffer_string),
			tempObj = instance_create_layer(room_width/2,room_height/2,"GUI",obj_test_player),
			data = new create_player_data(ip,port,-1,255,-1,-1,noone,tempObj);
			array_push(players,data); 
			tempObj.player = data;
			instance_create_layer(room_width,0,"GUI",obj_plain_text_box, {
				text: name +" connected on port " +string(port) +"."
			});
			
			buffer_seek(send_buffer,buffer_seek_start,0);
			buffer_write(send_buffer,buffer_u8,SEND.CONNECT);
			buffer_write(send_buffer,buffer_u16,port);
			network_send_udp(socket,ip,port,send_buffer,buffer_tell(send_buffer));
		break;
		case SEND.PING:
			buffer_seek(send_buffer,buffer_seek_start,0);
			buffer_write(send_buffer,buffer_u8,SEND.PING);
			network_send_udp(socket,ip,port,send_buffer,buffer_tell(send_buffer));
		break;
		case SEND.DISCONNECT:
			var
			name = "null";
			// Check port to delete
			for (var d = 0; d < arLeng; d++) {
				if port == players[d].port {
					// Check for if the player is hosting a match 
					if instance_exists(players[d].match) {
						//instance_destroy(players[d].match);
					}
					valid = true;
					name = players[d].name;
					instance_destroy(players[d].object);
					array_delete(players,d,1);
					break;
				}
			}
			if !valid {
				break;
			}
			arLeng = array_length(players);
			instance_create_layer(room_width,0,"GUI",obj_plain_text_box, {
				text: string(name) +" disconnected from port " +string(port) +"."
			});	
			// Send disconnect to everyone else
			for (var dd = 0; dd < arLeng; dd++) {
				if players[dd].status != ONLINESTATUS.IDLE {
					//continue;	
				}
				buffer_seek(send_buffer,buffer_seek_start,0);
				buffer_write(send_buffer,buffer_u8,SEND.DISCONNECT);
				buffer_write(send_buffer,buffer_u16,port);
				network_send_udp(socket,players[dd].ip,players[dd].port,send_buffer,buffer_tell(send_buffer));
			}
		break;
		case SEND.MATCHDATA:
			var dataID = undefined,
			readData = undefined,
			matchExists = false,
			updatePlayers = false,
			updateMatch = false,
			limiter = 0;
			// Find player in list 
			for (var i = 0; i < array_length(players); i++) {
				if players[i].port == port {
					if instance_exists(players[i].match) {
						matchExists = true;
					}
					break;	
				}
			}
			do {
				dataID = buffer_read(buffer_s,buffer_u8);
				if dataID == DATA.END {
					break;
				}
				if dataID == DATA.CREATEMATCH {
					var ranX = random_range(-64,64),
					ranY = random_range(-64,64);
					players[i].match = instance_create_layer(room_width/2 +ranX -room_width,room_height/2 +ranY,"GUI",obj_match_manager, {
						host_port: port,
						host_ip: ip
					});
					continue;
				}
				readData = read_data_buffer(buffer_s,dataID);
				switch dataID {
					// Player data
					case DATA.NAME:
						players[i].name = readData;
						updatePlayers = true;
					break;
					case DATA.STATUS:
						players[i].status = readData;
						updatePlayers = true;
					break;
					case DATA.HERO:
						players[i].hero = readData;
						updatePlayers = true;
					break;
					case DATA.LOADOUT:
						players[i].loadout = readData;
						updatePlayers = true;
					break;
					// Match data
					case DATA.MAXSLOTS:
						players[i].match.max_slots = readData;
						updateMatch = true;
					break;
					case DATA.SHOWSLOTS:
						players[i].match.show_opponent_slots = readData;
						updateMatch = true;
					break;
					case DATA.BARRIER:
						players[i].match.barrier_criteria = readData;
						updateMatch = true;
					break;
					case DATA.TIMELENGTH:
						players[i].match.timeruplength = readData;
						updateMatch = true;
					break;
					case DATA.MAXPIECES:
						players[i].match.max_pieces = readData;
						updateMatch = true;
					break;
					case DATA.MAP:
						players[i].match.map = readData;
						updateMatch = true;
					break;
				}
				limiter++;
			} until dataID == DATA.END || limiter > 32
			if updatePlayers {
				update_players = true;
			}
			if matchExists && updateMatch {
				players[i].match.update = true;
			}
		break;
		case SEND.GAMEDATA:
			// Can implement a way to read and verify actions later
			var gameData = json_parse(buffer_read(buffer_s,buffer_string)),
			stop = false;
			// For now mirror information to match object
			// Find if match exists
			for (var i = 0; i < array_length(players); i++) {
				if players[i].port == port {
					if instance_exists(players[i].match) {
						matchExists = true;
					}
					break;	
				}
			}
			if !matchExists {
				break;	
			}
			switch gameData.action {
				case DATA.LOSE:
					if players[i].match.winner == -1 {
						winner = port;
					} else {
						stop = true;	
					}
				break;
			}
			if !stop {
				array_push(players[i].match.requests,gameData);	
			}
		break;
		case SEND.TOGGLEJOIN:
			var sendTo = buffer_read(buffer_s,buffer_u16),
			sendFrom = port,
			foundTo = false,
			foundFrom = false;
			// Grab ip address to send to
			for	(var to = 0; to < arLeng; to++) {
				if players[to].port == sendTo {
					foundTo = true;
					break;
				}
			}
			// Grab ip address to return back info
			for	(var from = 0; from < arLeng; from++) {
				if players[from].port == sendFrom {
					foundFrom = true;
					break;
				}
			}
			if foundTo && foundFrom {
				var toMatch = players[to].match,
				fromMatch = players[from].match;
				// If they're in the match already, disconnect
				if (toMatch == fromMatch) {
					var resetStatus = false;
					with toMatch {
						// If player exiting is host, set new host port
						if host_port == port {
							if opponent_port != -1 {
								host_port = opponent_port;
								host_ip = opponent_ip;
								opponent_port = -1;	
								opponent_ip = -1;
							} else {
								// Abandon if no opponent
								instance_destroy();	
							}
							resetStatus = true;
						} else if opponent_port == port {
							opponent_port = -1;
							opponent_ip = -1;
							resetStatus = true;
						} else {
							for (var s = 0; s < array_length(spectator_ports); s++) {
								if spectator_ports[s] == port {
									array_delete(spectator_ports,s,1);
									array_delete(spectator_ips,s,1);
									break;
								}
							}
						}
					}
					players[from].match = noone;
					players[to].match.host_ready = false;
					players[to].match.opponent_ready = false;					
					if resetStatus && players[to].status == ONLINESTATUS.PREPARING {
						players[to].status = ONLINESTATUS.WAITING;
					}
				} else {
					with toMatch {
						// Only if there is no opponent, set opponent to that port
						if opponent_port == -1 {
							other.players[to].status = ONLINESTATUS.PREPARING;
							opponent_port = port;
							opponent_ip = ip;
						} else {
							array_push(spectator_ports,port);
							array_push(spectator_ips,ip);
						}
					}
					players[from].match = players[to].match;
				}
				update_players = true;
				buffer_seek(send_buffer,buffer_seek_start,0);
				buffer_write(send_buffer,buffer_u8,SEND.TOGGLEJOIN);
				buffer_write(send_buffer,buffer_u16,sendFrom);
				network_send_udp(socket,players[to].ip,sendTo,send_buffer,buffer_tell(send_buffer));	
				buffer_seek(send_buffer,buffer_seek_start,0);
				buffer_write(send_buffer,buffer_u8,SEND.TOGGLEJOIN);
				buffer_write(send_buffer,buffer_u16,sendTo);
				network_send_udp(socket,players[from].ip,sendFrom,send_buffer,buffer_tell(send_buffer));
				// Send extra match info
				buffer_seek(send_buffer,buffer_seek_start,0);
				buffer_write(send_buffer,buffer_u8,SEND.MATCHDATA);
				write_all_gamerule_data(send_buffer,toMatch.max_slots,toMatch.show_opponent_slots,toMatch.barrier_criteria,toMatch.timeruplength,toMatch.max_pieces,toMatch.map);
				buffer_write(send_buffer,buffer_u8,DATA.END);
				network_send_udp(socket,players[from].ip,sendFrom,send_buffer,buffer_tell(send_buffer));	
			} else {
				if sendTo == 0 {
					instance_destroy(players[from].match);
					players[from].match = noone;
					update_players = true;
				}
			}
		break;
		case SEND.READY:
			var found = false;
			// Find player's match
			for	(var r = 0; r < arLeng; r++) {
				if players[r].port == port {
					if instance_exists(players[r].match) {
						found = true;	
					}
					break;
				}
			}
			if !found {
				break;
			}
			with players[r].match {
				if host_port == port {
					host_ready = host_ready?false:true;	
				}
				if opponent_port == port {
					opponent_ready = opponent_ready?false:true;
				}
			}
		break;
	}
}
function process_packet_client(buffer_c) {
	// CLIENT	
	var ID = buffer_read(buffer_c,buffer_u8);
	switch ID {
		case SEND.CONNECT:
			// Grab port number for future reference
			if port == -1 {
				port = buffer_read(buffer_c,buffer_u16);
				connection_status = 1;
				var lD = {
					run: "Lobby",
					rm: rm_lobby,
					load: [standalone_soundtracks]
				}
				start_transition(sq_circle_out,sq_circle_in,lD);
			} else {
				var	dataInsert = new create_player_data(-1,buffer_read(buffer_c,buffer_u16),-1,-1,-1,-1,noone,noone);
				array_push(players,dataInsert);
			}
		break;
		case SEND.PING:
			with obj_ping {
				ping = current_time - past_time;
				send = true;
			}
		break;
		case SEND.MATCHDATA:
			// Update player data given 
			var dataID = buffer_read(buffer_c,buffer_u8),
			readData = undefined,
			dataInsert = undefined,
			i = 0,
			found = true,
			arLeng = array_length(players),
			limiter = 0;
			do {
				if limiter > 0 {
					dataID = buffer_read(buffer_c,buffer_u8);
				}
				if dataID == DATA.END {
					break;
				}
				readData = read_data_buffer(buffer_c,dataID);
				switch dataID {
					case DATA.PORT:
						found = false;
						// Find player in array
						for (i = 0; i < arLeng; i++) {
							if readData == players[i].port {
								found = true;
								break;
							}
						}
						if !found {
							dataInsert = new create_player_data(-1,readData,-1,-1,-1,-1,noone,noone);
							array_push(players,dataInsert);
						}
					break;
					case DATA.NAME:
						players[i].name = readData;
					break;
					case DATA.STATUS:
						players[i].status = readData;
					break;
					case DATA.HERO:
						players[i].hero = readData;
					break;
					case DATA.LOADOUT:
						players[i].loadout = readData;
						opponent_loadout = readData;
					break;
					case DATA.MAXSLOTS:
						global.max_slots = readData;
					break;
					case DATA.SHOWSLOTS:
						global.show_opponent_slots = readData;
					break;
					case DATA.BARRIER:
						global.barrier_criteria = readData;
					break;
					case DATA.TIMELENGTH:
						global.timeruplength = readData;
					break;
					case DATA.MAXPIECES:
						global.max_pieces = readData;
					break;
					case DATA.MAP:
						obj_map_switch.map = readData;
					break;
				}
				limiter++;
			} until dataID == DATA.END || limiter > 16
			update_players = true;
		break;
		case SEND.GAMEDATA:
			var gameData = json_parse(buffer_read(buffer_c,buffer_string));
			// Extra actions for each action
			switch gameData.action {
				case DATA.SPAWN:
					// Grab tag generated by server
					gameData.tag = buffer_read(buffer_c,buffer_u8);
				break;
			}	
			array_push(requests,gameData);
		break;
		case SEND.DISCONNECT:
			var portDisconnect = buffer_read(buffer_c,buffer_u16);
			if portDisconnect == opponent_port {
				opponent_port = -1;	
			}
			for (var d = 0; d < array_length(players);d++) {
				if portDisconnect == players[d].port {
					array_delete(players,d,1);
					d--;
				}
			}
			update_players = true;
		break;
		case SEND.TOGGLEJOIN:
			var portIn = buffer_read(buffer_c,buffer_u16);
			if portIn == opponent_port {
				opponent_port = -1;
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
							if room == rm_loadout_zone_multiplayer { shift_hero_displays(); }
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
				opponent_port = portIn;
			}
		break;
		case SEND.READY:
			random_set_seed(buffer_read(buffer_c,buffer_u32));
			
			var rGo = rm_level_normal;
			
			switch obj_map_switch.map {
				case 1: rGo = rm_level_normal; break;
				case 2: rGo = rm_level_small; break;
				case 3: rGo = rm_level_split; break;
				case 4: rGo = rm_level_conveyor; break;
			}
			if member_status == MEMBERSTATUS.HOST {
				global.player_team = "friendly";
				global.opponent_team = "enemy";
			}
			if member_status == MEMBERSTATUS.MEMBER {
				global.player_team = "enemy";
				global.opponent_team = "friendly";
			}
			game_status = ONLINESTATUS.INGAME;
			global.active_hero = obj_hero_display.identity;
			var arrayLength = instance_number(obj_loadout_slot);
			var array = array_create(arrayLength,0);
			with obj_loadout_slot {
				array[index] = identity;
			}
			global.max_turns = 30;
			global.friendly_turns = 20;
			global.enemy_turns = 20;
			global.loadout = array;
			room_goto(rGo);
		break;
	}
}