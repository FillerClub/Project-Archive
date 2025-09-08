function handle_full_state_sync(full_state, sync_tick) {
    show_debug_message("Applying full state sync for tick " + string(sync_tick));
    
    // Clear predictions and restore state
    ds_map_clear(prediction_history);
    load_save_state(full_state);
    //tick_count = sync_tick;
    
    show_debug_message("Full state sync completed");
}