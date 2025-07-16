if obj_ready.ready || obj_client_manager.member_status != MEMBERSTATUS.HOST {
	exit;	
}
var curX = obj_cursor.x,
sendUpdate = false,
increment = 0;
if position_meeting(curX,obj_cursor.y,self) {
	if input_check_pressed("action") {
		sendUpdate = true;
		if curX < x +sprite_width/2 {
			increment = -1;	
		} else {
			increment = 1;
		}
		// Clamp based on setting
		switch setting {
			case "Max Slots": global.max_slots = clamp(global.max_slots +increment,1,18); 
			break;
			case "Show Opponent's Picks": global.show_opponent_slots = clamp(global.show_opponent_slots +increment,false,true);
			break;
			case "Barrier Win Condition": global.barrier_criteria = clamp(global.barrier_criteria +increment,1,6);
			break;
			case "Time Until Timer Upgrade": global.timeruplength = clamp(global.timeruplength +increment*5,1,120);
			break;
			case "Max Pieces": global.max_pieces = clamp(global.max_pieces +increment*5,0,50);
			break;
		}
	}
	if mouse_check_button_pressed(mb_middle) {
		sendUpdate = true;
		switch setting {
			case "Max Slots":  global.max_slots= DEFAULT.MAXSLOTS;
			break;
			case "Show Opponent's Picks": global.show_opponent_slots = DEFAULT.SHOWSLOTS;
			break;
			case "Barrier Win Condition": global.barrier_criteria = DEFAULT.BARRIER;
			break;
			case "Time Until Timer Upgrade": global.timeruplength = DEFAULT.TIMELENGTH;
			break;
			case "Max Pieces": global.max_pieces = infinity;
			break;
		}	
	}
	if sendUpdate {
		with obj_client_manager {
			buffer_seek(send_buffer,buffer_seek_start,0);
			buffer_write(send_buffer,buffer_u8,SEND.MATCHDATA);
			switch other.setting {
				case "Max Slots":  write_data_buffer(send_buffer,DATA.MAXSLOTS,global.max_slots);
				break;
				case "Show Opponent's Picks": write_data_buffer(send_buffer,DATA.SHOWSLOTS,global.show_opponent_slots);
				break;
				case "Barrier Win Condition": write_data_buffer(send_buffer,DATA.BARRIER,global.barrier_criteria);
				break;
				case "Time Until Timer Upgrade": write_data_buffer(send_buffer,DATA.TIMELENGTH,global.timeruplength);
				break;
				case "Max Pieces": write_data_buffer(send_buffer,DATA.MAXPIECES,global.max_pieces);
				break;
			}
			buffer_write(send_buffer,buffer_u8,DATA.END);
			network_send_udp(socket,server_ip,server_port,send_buffer,buffer_tell(send_buffer));	
		}
	}
}
