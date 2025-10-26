function process_requests(requests, is_online = false) {
	var len = array_length(requests);
	if is_online && instance_exists(obj_client_manager) {
		// Process requests incoming from client
		if len <= 0 {
			exit;	
		}
		// Send request to host
		var action = array_shift(requests);
		if obj_client_manager.is_host {
			with obj_client_manager {
				buffer_action(action);
			}
		} else {
			create_prediction(action);	
		}
			
	} else {
		if len <= 0 {
			exit;	
		}
		// Skip straight to reading requests if not in online mode
		read_requests(requests,is_online);
	}
}