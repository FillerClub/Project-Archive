var type = async_load[? "type"]
switch type {
	case network_type_data:
		scr_client_handle_message(async_load[? "buffer"]);
	break;
}
/*var event_id = async_load[? "id"];

if socket == event_id {
	var type = async_load[? "type"];
	var buff = async_load[? "buffer"];
	var sock = async_load[? "socket"]
	
	buffer_seek(buff,buffer_seek_start, 0);
	var cmd = buffer_read(buff, buffer_u8);


	switch cmd {
		case PACKET_COMMAND:
			if instance_exists(obj_server) {
				exit;
			}		

			var c = buffer_read(buff, buffer_u16);

			switch c {
				case CMD_ROOM:
					room_goto(buffer_read(buff, buffer_u16));
					global.team = "enemy";
				break;
			}	
			
		break;
		
		case PACKET_SEED:
			var seed = buffer_read(buff, buffer_s32);
			random_set_seed(seed);
		break;
		
		case PACKET_NAME:
			var name = buffer_read(buff, buffer_string);
			if !instance_exists(obj_server) {
				global.othername = name;	
			}
		
			
		break;
		
		case PACKET_ENTITY:
			var c = buffer_read(buff, buffer_u8);
			var e_id = buffer_read(buff, buffer_u32);
			
			if !ds_map_exists(clientmap, e_id) {
				var p = instance_create_layer(0, 0, "Instances", obj_remote_entity);
				ds_map_set(clientmap, e_id, p);
			}
			
			var p = clientmap[? e_id];
			
				switch(c) {
					case CMD_X:
						p.x = buffer_read(buff,buffer_s16);
					break;
		
					case CMD_Y:
						p.y = buffer_read(buff,buffer_s16);
					break;
		
					case CMD_OBJECT:
						p.create = buffer_read(buff,buffer_u16);
					break;
		
					case CMD_SPRITE:
						p.sprite_index = buffer_read(buff,buffer_u16);
					break;
		
					case CMD_DESTROY:
						buffer_read(buff,buffer_u8);
						ds_map_delete(clientmap,e_id);
						with p {
							instance_destroy();	
						}
					break;					
				}
			
		break;
		
		case PACKET_ACTION_CLIENT:
			if instance_exists(obj_server) {
				exit;
			}
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
	}

}

