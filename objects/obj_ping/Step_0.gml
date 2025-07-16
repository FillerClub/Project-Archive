timer += delta_time*DELTA_TO_SECONDS;

if timer >= .2 && send {
	past_time = current_time;
	with obj_client_manager {
		buffer_seek(send_buffer,buffer_seek_start,0);
		buffer_write(send_buffer,buffer_u8,SEND.PING);
		network_send_udp(socket,server_ip,server_port,send_buffer,buffer_tell(send_buffer));	
	}
	timer = 0;	
	send = false;
}