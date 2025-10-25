function process_requests(requests, is_online = false) {
	var len = array_length(requests);
	if is_online && instance_exists(obj_client_manager) {
		// Process requests incoming from client
		if len <= 0 {
			exit;	
		}
		// Send requests to host
		// Make prediction immediately then send to host'
		var action = array_shift(requests);
		steam_relay_data(action);
		//action.prediction_id = generate_prediction_id();
        //store_prediction(action,save_state);
        //execute_action(action, true);
	} else {
		if len <= 0 {
			exit;	
		}
		// Skip straight to reading requests if not in online mode
		read_requests(requests,is_online);
	}
}