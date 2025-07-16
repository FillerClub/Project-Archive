function process_requests(ar, is_online = false) {
	var len = array_length(ar);
	if is_online {
		// Process requests incoming from client
		read_requests(obj_client_manager.requests,is_online);
		if len <= 0 {
			exit;	
		}
		// Send requests to server
		var struct = json_stringify(array_shift(ar));
		with obj_client_manager {
			buffer_seek(send_buffer,buffer_seek_start,0);
			buffer_write(send_buffer,buffer_u8,SEND.GAMEDATA);
			buffer_write(send_buffer,buffer_string,struct);
			network_send_udp(socket,server_ip,server_port,send_buffer,buffer_tell(send_buffer));			
		}
	} else {
		if len <= 0 {
			exit;	
		}
		// Skip straight to reading requests if not in online mode
		read_requests(requests);
	}
}