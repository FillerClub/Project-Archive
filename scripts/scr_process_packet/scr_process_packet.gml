function process_packet_server(buffer_s){
	// SERVER
	var 
	port = async_load[? "port"],
	ip = string(async_load[? "ip"]),
	valid = false,
	ID = buffer_read(buffer_s,buffer_u8);
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
		case SEND.DISCONNECT:
			var
			name = "null",
			arLeng = array_length(players);
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
				text: name +" disconnected from port " +string(port) +"."
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
		case SEND.DATA:
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
				if dataID == REMOTEDATA.END {
					break;
				}
				if dataID == REMOTEDATA.CREATEMATCH {
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
					case REMOTEDATA.NAME:
						players[i].name = readData;
						updatePlayers = true;
					break;
					case REMOTEDATA.STATUS:
						players[i].status = readData;
						updatePlayers = true;
					break;
					case REMOTEDATA.HERO:
						players[i].hero = readData;
						updatePlayers = true;
					break;
					case REMOTEDATA.LOADOUT:
						players[i].loadout = readData;
						updatePlayers = true;
					break;
					// Match data
					case REMOTEDATA.MAXSLOTS:
						players[i].match.max_slots = readData;
						updateMatch = true;
					break;
					case REMOTEDATA.SHOWSLOTS:
						players[i].match.show_opponent_slots = readData;
						updateMatch = true;
					break;
					case REMOTEDATA.BARRIER:
						players[i].match.barrier_criteria = readData;
						updateMatch = true;
					break;
					case REMOTEDATA.TIMELENGTH:
						players[i].match.timeruplength = readData;
						updateMatch = true;
					break;
					case REMOTEDATA.MAXPIECES:
						players[i].match.max_pieces = readData;
						updateMatch = true;
					break;
				}
				limiter++;
			} until dataID == REMOTEDATA.END || limiter > 32
			if updatePlayers {
				update_players = true;
			}
			if matchExists && updateMatch {
				players[i].match.update = true;
			}
		break;
		case SEND.TOGGLEJOIN:
			var sendTo = buffer_read(buffer_s,buffer_u16),
			sendFrom = port,
			foundTo = false,
			foundFrom = false,
			arLeng = array_length(players);
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
			} else {
				if sendTo == 0 {
					instance_destroy(players[from].match);
					players[from].match = noone;
					update_players = true;
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
		case SEND.DATA:
			// Update player data given 
			var dataID = buffer_read(buffer_c,buffer_u8),
			readData = undefined,
			dataInsert = undefined,
			index = 0,
			found = true,
			arLeng = array_length(players),
			limiter = 0;
			do {
				if limiter > 0 {
					dataID = buffer_read(buffer_c,buffer_u8);
				}
				if dataID == REMOTEDATA.END {
					break;
				}
				readData = read_data_buffer(buffer_c,dataID);
				switch dataID {
					case REMOTEDATA.PORT:
						found = false;
						// Find player in array
						for (index = 0; index < arLeng; index++) {
							if readData == players[index].port {
								found = true;
								break;
							}
						}
						if !found {
							dataInsert = new create_player_data(-1,readData,-1,-1,-1,-1,noone,noone);
							array_push(players,dataInsert);
						}
					break;
					case REMOTEDATA.NAME:
						players[index].name = readData;
					break;
					case REMOTEDATA.STATUS:
						players[index].status = readData;
					break;
					case REMOTEDATA.HERO:
						players[index].hero = readData;
					break;
					case REMOTEDATA.LOADOUT:
						players[index].loadout = readData;
					break;
					case REMOTEDATA.MAXSLOTS:
						global.max_slots = readData;
					break;
					case REMOTEDATA.SHOWSLOTS:
						global.show_opponent_slots = readData;
					break;
					case REMOTEDATA.BARRIER:
						global.barrier_criteria = readData;
					break;
					case REMOTEDATA.TIMELENGTH:
						global.timeruplength = readData;
					break;
					case REMOTEDATA.MAXPIECES:
						global.max_pieces = readData;
					break;
				}
				limiter++;
			} until dataID == REMOTEDATA.END || limiter > 16
			update_players = true;
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
				if game_status == ONLINESTATUS.PREPARING {
					game_status = ONLINESTATUS.WAITING;
					buffer_seek(send_buffer,buffer_seek_start,0);
					buffer_write(send_buffer,buffer_u8,SEND.DATA);
					write_data_buffer(send_buffer,REMOTEDATA.STATUS,game_status);
					buffer_write(send_buffer,buffer_u8,REMOTEDATA.END);
					network_send_udp(socket,server_ip,server_port,send_buffer,buffer_tell(send_buffer));
					if member_status == MEMBERSTATUS.MEMBER {
						shift_hero_displays();
						member_status = MEMBERSTATUS.HOST;
						create_system_message(["Host of current match has left, you are now host."])
					}
				}
			} else {
				opponent_port = portIn;
			}
		break;
	}
}