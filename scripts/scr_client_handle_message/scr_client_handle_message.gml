function scr_client_handle_message(){
	var gS = GRIDSPACE;
	var buff = argument0;

	while true {
		var message_id = buffer_read(buff, buffer_u8);

		
		switch message_id {
			case MESSAGE_JOIN:
				var client = buffer_read(buff, buffer_u16);
				var opponentObject = scr_opponent_get_object(client);				
			break;
			
			case MESSAGE_LEAVE:
				var client = buffer_read(buff, buffer_u16);
				var opponentObject = scr_opponent_get_object(client);
				scr_alert_text("Opponent left the match");
			break;
			
			case MESSAGE_START_GAME:
				var isPlayerFriendly = buffer_read(buff, buffer_bool);
				
				if !isPlayerFriendly {
					global.team = "enemy";
				} else { global.team = "friendly"; }
			
				buffer_seek(send_buffer, buffer_seek_start, 0);
				buffer_write(send_buffer, buffer_u8, MESSAGE_SEND_PROFILE);
				buffer_write(send_buffer, buffer_string, string(global.name));
		
				network_send_raw(socket, send_buffer, buffer_tell(send_buffer));				
				room_goto(rm_test);
			break;
			
			case MESSAGE_SEND_PROFILE:
				global.othername = 	buffer_read(buff, buffer_string);
			break;
			
			case MESSAGE_ACTION:
				var actionMSG = buffer_read(buff, buffer_u8);
				var isFriendly = buffer_read(buff, buffer_bool);	
				
				switch actionMSG {
					case CREATE:
						var xC = buffer_read(buff, buffer_s32);
						var yC = buffer_read(buff, buffer_s32);		
						var Create = buffer_read(buff, buffer_u16);	

						
						instance_create_layer(xC,yC,"Instances",Create, {
							dragging: false,
							fresh: false,
							moveable: false,		
							team: (isFriendly)?"friendly":"enemy",
							deduct_cost: true,
						});		
					break;
					
					case MOVE:
						var xC = buffer_read(buff, buffer_s32);
						var yC = buffer_read(buff, buffer_s32);		
						var xCnew = buffer_read(buff, buffer_s32);
						var yCnew = buffer_read(buff, buffer_s32);	
						
						with instance_nearest(xC,yC,obj_obstacle) {
							x = xCnew;
							y = yCnew;
							grid_pos = [xCnew/gS,yCnew/gS];	
						}
						if isFriendly {
							global.turns -= 1;
						} else {
							global.enemy_turns -= 1;					
						}	

						
					break;
					
					case ABILITY:
						var xC = buffer_read(buff, buffer_s32);
						var yC = buffer_read(buff, buffer_s32);	
						with instance_place(xC,yC,obj_obstacle) {
							execute = "ability";
							bypass_mode = true;								
						}
					break;
					
					case DESTROY:
//						audio_play_sound(snd_explosion,0,0);
						var xC = buffer_read(buff, buffer_s32);
						var yC = buffer_read(buff, buffer_s32);	
						with instance_place(xC,yC,obj_obstacle) {
							instance_destroy();						
						}
					break;
				}
			break;
		}
		
		if buffer_tell(buff) == buffer_get_size(buff) {
			break;
		}
	}
}