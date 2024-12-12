
/*var event_id = async_load[? "id"]


if server == event_id {
	var type = async_load[? "type"]
	var sock = async_load[? "socket"]
	
	// connect
	if type == network_type_connect {
		// create a player, add socket to list
		ds_list_add(sockets, sock);	
		
		// create a player
		var p = instance_create_layer(100,-100 -32*sock,"Instances",obj_online_player)
		
		ds_map_add(clients, sock, p);
		
	}
	
	// disconnect
	if type == network_type_disconnect {
		var p = clients[? sock];
		 if (instance_exists(p)) {
			with p {
				instance_destroy();	
			}
		}
		ds_list_delete(sockets, ds_list_find_index(sockets, sock));
		ds_map_delete(clients, sock);
	}
} else if event_id != global.socket {
	var sock = async_load[? "id"];
	var buff = async_load[? "buffer"];
	
	buffer_seek(buff, buffer_seek_start, 0);
	var cmd = buffer_read(buff, buffer_u8);
	
	var p = clients[? sock];
	
	switch cmd {
		case PACKET_ACTION:
			var o = buffer_read(buff, buffer_u8);
			var oX = buffer_read(buff, buffer_s32);
			var oY = buffer_read(buff, buffer_s32);
			var comm = buffer_read(buff, buffer_u8);
				
			switch comm {
				case CREATE:	
					instance_create_layer(oX,oY,"Instances",o, {
					dragging: false,
					fresh: false,
					moveable: false,		
					team: (global.team == "friendly")?"enemy":"friendly",					
					});
				break;
			
				case ABILITY:
					with instance_nearest(oX,oY,o) {
						execute = "ability";
						bypass_mode = true;
					}
					
				break;

				case MOVE:
					var oXn = buffer_read(buff, buffer_s32);
					var oYn = buffer_read(buff, buffer_s32);
					var gS = global.grid_spacing;
					with instance_nearest(oX,oY,obj_generic_piece) {
							x = oXn;
							y = oYn;
							grid_pos = [oXn/gS,oYn/gS];	
					}
				break;
			}
		break;
		
		case PACKET_NAME:		
			with p {
				global.othername = buffer_read(buff,buffer_string);		
			}
		break;
	}

}
// send data on room
if room != rm_test {
	if  ds_list_size(sockets) = 2 {
			for (var s = 0; s < ds_list_size(sockets); s++) {
				var so = ds_list_find_value(sockets, s);
				scr_send_to_client(so, CMD_ROOM, rm_test);
				scr_send_to_client_seed(so, random_get_seed());				
				scr_send_name_to_client(so, global.name);
			}

			room_goto(rm_test);
	}
}