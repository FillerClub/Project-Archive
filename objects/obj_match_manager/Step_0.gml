if update {
	with obj_server_manager {
		// Write updated rules
		buffer_seek(send_buffer, buffer_seek_start,0);
		buffer_write(send_buffer, buffer_u8,SEND.DATA);
		write_all_gamerule_data(send_buffer,other.max_slots,other.show_opponent_slots,other.barrier_criteria,other.timeruplength,other.max_pieces)
		buffer_write(send_buffer, buffer_u8,REMOTEDATA.END);
		// Send buffer to opponent, since host already dictated rules
		network_send_udp(socket,other.opponent_ip,other.opponent_port,send_buffer,buffer_tell(send_buffer));
	}
	update = false;
}	