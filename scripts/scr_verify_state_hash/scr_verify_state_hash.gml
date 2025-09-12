function verify_state_hash(host_hash, hash_tick) {
    // Small delay to let any pending actions complete
	var verifyHash = {
		host_hash: host_hash,
		hash_tick, hash_tick,
	}
	with obj_battle_handler {
		verify_hash = verifyHash; 	
	}
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
}