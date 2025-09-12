function process_requests(requests, is_online = false) {
	var len = array_length(requests);
	if is_online && instance_exists(obj_client_manager) {
		read_requests(obj_client_manager.requests,is_online);
		if verify_hash != -1 {
			with obj_client_manager {
				detect_desync(other.verify_hash.host_hash,other.verify_hash.hash_tick);
			}
			verify_hash = -1;	
		}
		// Process requests incoming from client
		if len <= 0 {
			exit;	
		}
		// Send requests to host
		// Make prediction immediately then send to host'
		var action = array_shift(requests);
		action.prediction_id = generate_prediction_id();
        store_prediction(action,save_state);
        execute_action(action, is_online);
		steam_relay_data(action);
	} else {
		if len <= 0 {
			exit;	
		}
		// Skip straight to reading requests if not in online mode
		read_requests(requests,is_online);
	}
}