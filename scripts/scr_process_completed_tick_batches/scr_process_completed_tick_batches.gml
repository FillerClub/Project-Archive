function process_completed_tick_batches() {
    var process_tick = tick_count - batch_delay;
    
    if (ds_map_exists(tick_action_batches, process_tick)) {
        var batch_actions = ds_map_find_value(tick_action_batches, process_tick);
        
        if (array_length(batch_actions) > 0) {
            // Track all received prediction IDs
            var received_predictions = [];
            for (var i = 0; i < array_length(batch_actions); i++) {
                if (variable_struct_exists(batch_actions[i], "prediction_id")) {
                    array_push(received_predictions, batch_actions[i].prediction_id);
                }
            }
            
            // Process with your existing system
            var deduplicated = deduplicate_actions(batch_actions);
            var resolved = resolve_conflicts(deduplicated);
            var prioritized = sort_actions_by_execution_priority(resolved);
            
            // Track which predictions survived processing
            var accepted_predictions = [];
            for (var i = 0; i < array_length(prioritized); i++) {
                if (variable_struct_exists(prioritized[i], "prediction_id")) {
                    array_push(accepted_predictions, prioritized[i].prediction_id);
                }
            }
            
            // Calculate rejected predictions
            var rejected_predictions = [];
            for (var i = 0; i < array_length(received_predictions); i++) {
                var pred_id = received_predictions[i];
                var found = false;
                for (var j = 0; j < array_length(accepted_predictions); j++) {
                    if (accepted_predictions[j] == pred_id) {
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    array_push(rejected_predictions, pred_id);
                }
            }
            
            // Send comprehensive result
            var processed_batch = {
                Message: SEND.PROCESSED_TICK,
                tick: process_tick,
                accepted_actions: prioritized,
                rejected_predictions: rejected_predictions
            };
			store_executed_actions(process_tick, prioritized);
            steam_bounce(processed_batch);
        }
        
        ds_map_delete(tick_action_batches, process_tick);
    }
}