function handle_full_resync(packet) {
	show_debug_message("=== RECEIVING FULL STATE RESYNC ===");
    
    // Clear all predictions
	with obj_battle_handler {
		ds_map_clear(prediction_history);
		prediction_id_counter = 0;
	}
    
    // Load full state
    load_save_state(packet.state_data,packet.time_stamp);
    
	// Reset counter to allow system to transition back to minor state corrections
	resync_attempt_count = max_total_resync_attempts +1;
    show_debug_message("Full resync complete");
}