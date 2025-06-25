if connection_status == 1 {
	buffer_seek(send_buffer, buffer_seek_start,0);
	buffer_write(send_buffer, buffer_u8,SEND.DISCONNECT); 
	network_send_udp(socket,server_ip,server_port,send_buffer,buffer_tell(send_buffer));	
}