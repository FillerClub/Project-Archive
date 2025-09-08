function perform_rollbacks(rollback_states) {
    // Sort by timestamp (oldest first)
    array_sort(rollback_states, function(a, b) {
        var a_prediction = ds_map_find_value(obj_online_battle_handler.prediction_history, a.prediction_id);
        var b_prediction = ds_map_find_value(obj_online_battle_handler.prediction_history, b.prediction_id);
        return a_prediction.timestamp - b_prediction.timestamp;
    });
    
    for (var i = 0; i < array_length(rollback_states); i++) {
        var rollback = rollback_states[i];
        
        show_debug_message("Rolling back prediction: " + rollback.prediction_id);
        
        // Restore state before the bad prediction
        load_save_state(rollback.state, rollback.timestamp);
        
        // Execute the correct action (if any)
        if (rollback.correct_action != noone) {
			array_push(requests, rollback.correct_action);
        }
        // If correct_action is noone, it was rejected - just restore state
        
        // Re-execute any predictions that happened after this one
        replay_newer_predictions(rollback.prediction_id);
    }
}