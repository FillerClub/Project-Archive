if position_meeting(obj_cursor.x,obj_cursor.y,self) && input_check_pressed("action") {
	with obj_client_manager {
		if game_status == ONLINESTATUS.MATCHHOST || game_status == ONLINESTATUS.MATCHGUEST {
			game_status = ONLINESTATUS.IDLE;
			buffer_seek(send_buffer,buffer_seek_start,0);
			buffer_write(send_buffer,buffer_u8,SEND.DATA);
			write_data_buffer(send_buffer,REMOTEDATA.STATUS,game_status);
			buffer_write(send_buffer,buffer_u8,REMOTEDATA.END);
			network_send_udp(socket,server_ip,server_port,send_buffer,buffer_tell(send_buffer));			
		}
	}
	var lD = {
		run: "Nothing",
		rm: rm_lobby,
	}
	start_transition(INSTANT,INSTANT,lD);	
}