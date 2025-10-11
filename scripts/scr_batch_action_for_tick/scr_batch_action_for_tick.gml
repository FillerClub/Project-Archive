function batch_action_for_tick(action) {
    
	// Add to current tick's batch
    if (!ds_map_exists(tick_action_batches, tick_count)) {
        ds_map_set(tick_action_batches, tick_count, []);
    }
    
    var tick_batch = ds_map_find_value(tick_action_batches, tick_count);
    array_push(tick_batch, action);
    ds_map_set(tick_action_batches, tick_count, tick_batch);
	log_debug("BATCH: Received action " + action.action + " with ID " + string(action.prediction_id), c_aqua);
}