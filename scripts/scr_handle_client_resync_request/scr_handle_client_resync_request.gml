function handle_client_resync_request(request) {
    var client_id = request.client_id;
    
    show_debug_message("Client " + string(client_id) + " requested resync at tick " + string(tick_count));
    
    // Create comprehensive resync package
    var resync_response = {
        Message: SEND.FULL_RESYNC,
        tick: tick_count,
        full_state: create_save_state(),
        state_hash: calculate_state_hash(),
        recent_actions: get_recent_executed_actions(20) // Last 20 ticks of actions
    };
	send_packet_to_client(client_id, resync_response);
    // Send directly to requesting client only

    /*
    // Log the resync for debugging
    if (instance_exists(obj_debugger)) {
        with (obj_debugger) {
            log_debug("Sent full resync to client " + string(client_id), c_orange);
            desync_count++;
        }
    }
	*/
	
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