function process_tick() {
    current_tick++;
	var debugMessage = "",
	verbose = global.verbose_debug;
	
	if verbose {
		debugMessage = "AT TICK - " + string(current_tick) +"\n";	
	}
    // Calculate which tick to process
    var processTick = current_tick - processing_delay;
    if processTick < 0 {
        return;  // Not enough ticks elapsed yet
    }
    // Check if there are actions to process
    if ds_map_exists(action_buffer, processTick) {
        var tick_actions = action_buffer[? processTick];
        if verbose {
            debugMessage += "Processing " + string(array_length(tick_actions)) + " actions for tick " + string(processTick);
        }
        // Process this tick's actions
        var results = process_tick_batch(tick_actions);
        // Send results to clients
        broadcast_tick_results(processTick, results);
        // Clean up processed tick
        ds_map_delete(action_buffer, processTick);
		if verbose {
			show_debug_message(debugMessage);	
		}
    }
    
	// Hash checking
    hash_check_timer++;
    if hash_check_timer >= hash_check_interval {
        hash_check_timer = 0;
        send_hash_check();
    }
	
    // Clean up old ticks
    var cleanup_tick = processTick - 10;
    if ds_map_exists(action_buffer, cleanup_tick) {
        ds_map_delete(action_buffer, cleanup_tick);
    }
}