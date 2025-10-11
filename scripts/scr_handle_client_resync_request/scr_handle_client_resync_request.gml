function handle_client_resync_request(request) {
    var client_id = request.client_id;
	var severity = request.resync_severity;
	var resync_response = {
        Message: SEND.PERIODIC_SYNC        
    };
	if severity <= 0 {
		show_debug_message("Client " + string(client_id) + " requested resync at tick " + string(tick_count));
		resync_response.detailed_state = capture_detailed_state();
	} else {
		show_debug_message("Client " + string(client_id) + " requested full resync at tick " + string(tick_count));	
		resync_response.full_state = create_save_state();
		var timeOffset = 0;
		with obj_online_battle_handler {
			timeOffset = game_clock_start;
		}
		resync_response.timestamp = get_timer() -timeOffset;
	}
    // Create comprehensive resync package
	send_packet_to_client(client_id, resync_response);
    // Send directly to requesting client only
    // Log the resync for debugging
    if (instance_exists(obj_debugger)) {
        with (obj_debugger) {
            if severity <= 0 {
				log_debug("Sent resync to client " + string(client_id), c_green);
			} else {
				log_debug("Sent full resync to client " + string(client_id), c_aqua);
			}
			
            desync_count++;
        }
    }	
}
function get_recent_executed_actions(tick_count_back) {
    // Return actions from recent ticks so client can understand what led to current state
    var recent_actions = [];
    
    for (var i = max(0, tick_count - tick_count_back); i <= tick_count; i++) {
        // If you're storing action history in executed_actions_history map
        if (ds_map_exists(executed_actions_history, i)) {
            var tick_actions = ds_map_find_value(executed_actions_history, i);
            if (array_length(tick_actions) > 0) {
                array_push(recent_actions, {
                    tick: i,
                    actions: tick_actions
                });
            }
        }
    }
}