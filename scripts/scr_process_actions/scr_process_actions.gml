function process_requests(ar, is_online = false) {
	var len = array_length(ar);
	if is_online {
		// Process requests incoming from client
		read_requests(obj_client_manager.requests,is_online);
		if len <= 0 {
			exit;	
		}
		// Send requests to server
		steam_bounce(array_shift(ar));
	} else {
		if len <= 0 {
			exit;	
		}
		// Skip straight to reading requests if not in online mode
		read_requests(requests);
	}
}