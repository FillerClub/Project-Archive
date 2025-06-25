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
			tempObj = instance_create_layer(room_width/2,room_height/2,"GUI",obj_test_player, {
			name: name,
			port: port
			}),
			data = new create_player_data(ip,port,name,ONLINESTATUS.IDLE,-1,-1,tempObj);
			array_push(players,data); 
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
			name = "null";
			// Check port to delete
			for (var d = 0; d < array_length(players); d++) {
				if port == players[d].port {
					valid = true;
					name = players[d].name;
					instance_destroy(players[d].object);
					array_delete(players,d,1);
					d--;
					continue;
				}
				if players[d].status == ONLINESTATUS.IDLE {
					buffer_seek(send_buffer,buffer_seek_start,0);
					buffer_write(send_buffer,buffer_u8,SEND.DISCONNECT);
					buffer_write(send_buffer,buffer_u16,port); 
					network_send_udp(socket,players[d].ip,players[d].port,send_buffer,buffer_tell(send_buffer));	
				}
			}
			update_players = true;
			if valid {
				instance_create_layer(room_width,0,"GUI",obj_plain_text_box, {
					text: name +" disconnected from port " +string(port) +"."
				});	
			}
		break;
		case SEND.DATA:
			var dataID = undefined,
			readData = undefined,
			limiter = 0;
			// Check port to modify data of
			for (var d = 0; d < array_length(players); d++) {
				if port == players[d].port {
					valid = true;
					break;
				}
			}
			if !valid {
				break;	
			}
			do {
				dataID = buffer_read(buffer_s,buffer_u8);
				if dataID == REMOTEDATA.END {
					break;
				}
				readData = read_data_buffer(buffer_s,dataID);
				switch dataID {
					case REMOTEDATA.NAME:
						players[d].name = readData;
					break;
					case REMOTEDATA.STATUS:
						players[d].status = readData;
					break;
					case REMOTEDATA.HERO:
						players[d].hero = readData;
					break;
					case REMOTEDATA.LOADOUT:
						players[d].loadout = readData;
					break;
				}
				limiter++;
			} until dataID == REMOTEDATA.END || limiter > 16
			// Update other players
			for (var dd = 0; dd < array_length(players); dd++) {
				if players[dd].status != ONLINESTATUS.IDLE {
					continue;	
				}
				for (var ddd = 0; ddd < array_length(players); ddd++) {
					buffer_seek(send_buffer, buffer_seek_start,0);
					buffer_write(send_buffer, buffer_u8,SEND.DATA);
					write_data_buffer(send_buffer,REMOTEDATA.PORT,players[ddd].port);
					write_data_buffer(send_buffer,REMOTEDATA.NAME,players[ddd].name);
					write_data_buffer(send_buffer,REMOTEDATA.STATUS,players[ddd].status);
					buffer_write(send_buffer, buffer_u8,REMOTEDATA.END);
					network_send_udp(socket,players[dd].ip,players[dd].port,send_buffer,buffer_tell(send_buffer));
				}		
			}
			update_players = true;
		break;
	}
}
function process_packet_client(buffer_c){
	// CLIENT	
	var ID = buffer_read(buffer_c,buffer_u8);
	switch ID {
		case SEND.CONNECT:
			// Grab port number for future reference
			port = buffer_read(buffer_c,buffer_u16);
			connection_status = 1;
			var lD = {
				run: "Lobby",
				rm: rm_lobby,
				load: [standalone_soundtracks]
			}
			start_transition(sq_circle_out,sq_circle_in,lD);
		break;
		case SEND.DATA:
			// Read player status
			var dataID = undefined,
			readData = undefined,
			list = obj_player_list,
			tempStruct = new create_player_data(-1,-1,-1,-1,-1,-1,noone),
			isNew = array_length(players) < 0,
			limiter = 0;
			do {
				dataID = buffer_read(buffer_c,buffer_u8);
				if dataID == REMOTEDATA.END {
					break;
				}
				readData = read_data_buffer(buffer_c,dataID);
				switch dataID {
					case REMOTEDATA.NAME:
						tempStruct.name = readData;
					break;
					case REMOTEDATA.STATUS:
						audio_play_sound(snd_beam,0,0);
						tempStruct.status = readData;
					break;
					case REMOTEDATA.HERO:
						tempStruct.hero = readData;
					break;
					case REMOTEDATA.LOADOUT:
						tempStruct.loadout = readData;
					break;
					case REMOTEDATA.PORT:
						tempStruct.port = readData;
					break;
				}
				limiter++;
			} until dataID == REMOTEDATA.END || limiter > 16
			var checkOld = false;
			if !isNew {
				for (var d = 0; d < array_length(players); d++) {
					if players[d].port == tempStruct.port {
						checkOld = true;
						break;
					}	
				}

			}	
			if port == tempStruct.port && tempStruct.port != -1 {
				break;
			}
			if !checkOld {
				players[d] = new create_player_data(-1,tempStruct.port,tempStruct.name,tempStruct.status,tempStruct.hero,tempStruct.loadout,noone);
			} else {
				player[d] = tempStruct;	
			}
		break;
		case SEND.DISCONNECT:
			var portDisconnect = buffer_read(buffer_c,buffer_u16);
			for (var d = 0; d < array_length(players);d++) {
				if portDisconnect == players[d].port {
					array_delete(players,d,1);
					d--;
				}
			}
		break;
	}
}