function match_togglejoin(target_port = -1){
	var sendFinal = false,
	sendPort = target_port;
	if (target_port == -1 && opponent_port != -1) ||
	(target_port != -1 && opponent_port == -1) {
		if sendPort == -1 {
			if opponent_port != -1 {
				sendPort = opponent_port;
			}
		}
	} else {
		// Disconnect
		sendPort = 0;	
	}
	buffer_seek(send_buffer,buffer_seek_start,0);
	buffer_write(send_buffer,buffer_u8,SEND.TOGGLEJOIN);
	buffer_write(send_buffer,buffer_u16,sendPort);
	network_send_udp(socket,server_ip,server_port,send_buffer,buffer_tell(send_buffer));
}