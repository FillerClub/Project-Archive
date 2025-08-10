function match_togglejoin(target_id = -1){
	var sendFinal = false,
	sendID = target_player;
	if (target_id == -1 && opponent_id != -1) ||
	(target_id != -1 && opponent_id == -1) {
		if sendID == -1 {
			if opponent_id != -1 {
				sendID = opponent_id;
			}
		}
	} else {
		// Disconnect
		sendID = "d";	
	}
	buffer_seek(send_buffer,buffer_seek_start,0);
	buffer_write(send_buffer,buffer_u8,SEND.TOGGLEJOIN);
	buffer_write(send_buffer,buffer_string,sendID);
	network_send_udp(socket,server_ip,server_port,send_buffer,buffer_tell(send_buffer));
}