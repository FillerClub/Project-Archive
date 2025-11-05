function request_full_resync() {
    resync_attempt_count++;
    
    if resync_attempt_count > max_total_resync_attempts {
        show_debug_message("=== CRITICAL: Multiple resync attempts failed ===");
        show_debug_message("Connection may be unstable or game state is broken");
        // Could disconnect client here as last resort
        // return;
    }
	show_debug_message("Requesting FULL RESYNC (attempt " + string(resync_attempt_count) + ")");
    var packet = {
        Message: SEND.FULL_RESYNC,
        player_id: obj_preasync_handler.steam_id
    };
    
    steam_relay_data(packet);
}