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
			data = new create_player_data(ip,port,"null",255,"null","null",tempObj);
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
			limiter = 0;
			// Find player in list 
			for (var i = 0; i < array_length(players); i++) {
				if players[i].port == port {
					break;	
				}
			}
			do {
				dataID = buffer_read(buffer_s,buffer_u8);
				if dataID == REMOTEDATA.END {
					break;
				}
				readData = read_data_buffer(buffer_s,dataID);
				switch dataID {
					case REMOTEDATA.NAME:
						players[i].name = readData;
					break;
					case REMOTEDATA.STATUS:
						players[i].status = readData;
					break;
					case REMOTEDATA.HERO:
						players[i].hero = readData;
					break;
					case REMOTEDATA.LOADOUT:
						players[i].loadout = readData;
					break;
				}
				limiter++;
			} until dataID == REMOTEDATA.END || limiter > 16
			update_players = true;
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
				var	dataInsert = new create_player_data(-1,buffer_read(buffer_c,buffer_u16),-1,-1,-1,-1,noone);
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
			if dataID != REMOTEDATA.PORT {
				instance_create_layer(room_width,0,"GUI",obj_plain_text_box, {
					text: "ERROR: SERVER SENT DATA W/OUT SPECIFYING PORT FIRST"
				});	
				break;	
			}
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
							dataInsert = new create_player_data(-1,readData,"null",-1,"null","null",noone);
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
				}
				limiter++;
			} until dataID == REMOTEDATA.END || limiter > 16
			update_players = true;
		break;
		case SEND.DISCONNECT:
			var portDisconnect = buffer_read(buffer_c,buffer_u16);
			for (var d = 0; d < array_length(players);d++) {
				if portDisconnect == players[d].port {
					array_delete(players,d,1);
					d--;
				}
			}
			update_players = true;
		break;
	}
}