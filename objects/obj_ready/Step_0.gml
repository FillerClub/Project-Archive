if position_meeting(obj_cursor.x,obj_cursor.y,self) {
	if input_check_pressed("action") {
		ready = ready?false:true;
		audio_play_sound(snd_timer_cycle,0,0);
		with obj_client_manager {
			buffer_seek(send_buffer,buffer_seek_start,0);
			buffer_write(send_buffer,buffer_u8,SEND.MATCHDATA);
			write_data_buffer(send_buffer,DATA.LOADOUT,global.loadout);
			buffer_write(send_buffer,buffer_u8,DATA.END);
			network_send_udp(socket,server_ip,server_port,send_buffer,buffer_tell(send_buffer));	
			buffer_seek(send_buffer,buffer_seek_start,0);
			buffer_write(send_buffer,buffer_u8,SEND.READY);
			network_send_udp(socket,server_ip,server_port,send_buffer,buffer_tell(send_buffer));
		}
	}
}