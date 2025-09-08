function verify_state_hash(host_hash, hash_tick) {
    // Small delay to let any pending actions complete
    function detect_desync(hash,tick) {
		var local_hash = calculate_state_hash();
        
        if (local_hash != hash) {
            show_debug_message("Hash mismatch at tick " + string(tick));
            show_debug_message("Local: " + local_hash);
            show_debug_message("Host: " + hash);
            request_detailed_comparison();
        } else {
            show_debug_message("State hash verified for tick " + string(tick));
        }			
	}
	call_later(.1, time_source_units_seconds, detect_desync(host_hash,hash_tick), false);
}