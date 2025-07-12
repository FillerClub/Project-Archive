if position_meeting(obj_cursor.x,obj_cursor.y,self) && input_check_pressed("action") {
	with obj_match_setting_switch {
		switch setting {
			case "Max Slots": global.max_slots = setting_value; break;
			case "Show Opponent's Picks": global.show_opponent_slots = setting_value; break;
			case "Barrier Win Condition": global.barrier_criteria = setting_value; break;
			case "Time Until Timer Upgrade": global.timeruplength = setting_value; break;
			case "Max Pieces": global.max_pieces = setting_value; break;
		}	
	}
	with obj_client_manager {
		buffer_seek(send_buffer,buffer_seek_start,0);
		buffer_write(send_buffer,buffer_u8,SEND.DATA);
		write_all_gamerule_data(send_buffer,global.max_slots,global.show_opponent_slots,global.barrier_criteria,global.timeruplength,global.max_pieces);
		buffer_write(send_buffer,buffer_u8,REMOTEDATA.END);
		network_send_udp(socket,server_ip,server_port,send_buffer,buffer_tell(send_buffer));	
	}
	room_goto(rm_loadout_zone_multiplayer);
}
