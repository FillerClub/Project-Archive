if position_meeting(obj_cursor.x,obj_cursor.y,self) && input_check_pressed("action") && global.game_state == RUNNING {
	with obj_client_manager {
		game_status = ONLINESTATUS.IDLE;
		match_togglejoin();
		buffer_seek(send_buffer,buffer_seek_start,0);
		buffer_write(send_buffer,buffer_u8,SEND.DATA);
		write_data_buffer(send_buffer,REMOTEDATA.STATUS,game_status);
		buffer_write(send_buffer,buffer_u8,REMOTEDATA.END);
		network_send_udp(socket,server_ip,server_port,send_buffer,buffer_tell(send_buffer));			
	}
	room_goto(rm_lobby);
}