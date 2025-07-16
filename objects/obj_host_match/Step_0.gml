if position_meeting(obj_cursor.x,obj_cursor.y,self) && input_check_pressed("action") {
	with obj_client_manager {
		game_status = ONLINESTATUS.WAITING;
		member_status = MEMBERSTATUS.HOST;
		buffer_seek(send_buffer,buffer_seek_start,0);
		buffer_write(send_buffer,buffer_u8,SEND.MATCHDATA);
		write_data_buffer(send_buffer,DATA.STATUS,game_status);
		buffer_write(send_buffer,buffer_u8,DATA.CREATEMATCH);
		write_all_gamerule_data(send_buffer,global.max_slots,global.show_opponent_slots,global.barrier_criteria,global.timeruplength,global.max_pieces,1);
		buffer_write(send_buffer,buffer_u8,DATA.END);
		network_send_udp(socket,server_ip,server_port,send_buffer,buffer_tell(send_buffer));
	}
	room_goto(rm_loadout_zone_multiplayer);
}