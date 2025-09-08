function handle_prediction_results(packet) {
    var auth_actions = packet.accepted_actions;
    var rejected_predictions = packet.rejected_predictions;
    
    var rollback_needed = false;
    var rollback_states = [];
	var predictions_to_cleanup = []; // Store IDs to delete later
    
    // Handle accepted actions 
    for (var i = 0; i < array_length(auth_actions); i++) {
        var auth_action = auth_actions[i];
        var prediction_id = auth_action.prediction_id;
        
        // Check if this was our prediction
        if (ds_map_exists(obj_online_battle_handler.prediction_history, prediction_id)) {
            var prediction_data = ds_map_find_value(obj_online_battle_handler.prediction_history, prediction_id);
            
            if (!actions_equivalent(prediction_data.action, auth_action)) {
                // Prediction was modified - need rollback
                show_debug_message("Prediction modified: " + prediction_id);
                array_push(rollback_states, {
                    state: prediction_data.state,
                    correct_action: auth_action,
                    prediction_id: prediction_id
                });
                rollback_needed = true;
            } else {
                show_debug_message("Prediction confirmed: " + prediction_id);
            }
            
            // Don't delete yet - add to cleanup list
            array_push(predictions_to_cleanup, prediction_id);
        } else {
            // This was someone else's action - queue to be executed normally
            array_push(requests, auth_action);
        }
    }
    
    // Handle rejected predictions
    for (var i = 0; i < array_length(rejected_predictions); i++) {
        var rejected_id = rejected_predictions[i];
        
        if (ds_map_exists(obj_online_battle_handler.prediction_history, rejected_id)) {
            var prediction_data = ds_map_find_value(obj_online_battle_handler.prediction_history, rejected_id);
            
            show_debug_message("Prediction rejected: " + rejected_id);
            
            // Rollback the rejected prediction
            array_push(rollback_states, {
                state: prediction_data.state,
                correct_action: noone, // No replacement action
                prediction_id: rejected_id,
				timestamp: prediction_data.timestamp
            });
            rollback_needed = true;
			
			// Don't delete yet - add to cleanup list
            array_push(predictions_to_cleanup, rejected_id);
        }
    }
    
    // Perform rollbacks if needed
    if (rollback_needed) {
        perform_rollbacks(rollback_states);
    }
	// NOW clean up predictions after rollback is complete
    for (var i = 0; i < array_length(predictions_to_cleanup); i++) {
        ds_map_delete(obj_online_battle_handler.prediction_history, predictions_to_cleanup[i]);
    }
}