function handle_full_state_sync(packet) {
    show_debug_message("Applying full state sync for tick " + string(packet.tick));
    
    // Clear predictions and restore state
    with obj_battle_handler {
		ds_map_clear(prediction_history);	
	}
    load_save_state(packet.full_state,packet.timestamp);
    //tick_count = sync_tick;
    
    show_debug_message("Full state sync completed");
}