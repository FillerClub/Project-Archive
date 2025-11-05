function hash_check(packet) {
    // Calculate local hash
    var local_hash = calculate_state_hash(),
    host_hash = packet.hash,
	verbose = global.verbose_debug;
    
    if local_hash == host_hash {
        if verbose {
			if resync_attempt_count >= 2 {
				show_debug_message("Hashes stabilizing: " + local_hash);	
			} else if resync_attempt_count < 2 && resync_attempt_count > 0 {
				show_debug_message("Hashes stabilized: " + local_hash);	
			} else {
				show_debug_message("Hashes verified: " + local_hash);
			}
        }
		// Dock from counter for every successful hash match
		resync_attempt_count = max(resync_attempt_count -1,0);
    } else {
        // DESYNC DETECTED
        show_debug_message("=== DESYNC DETECTED ===");
        show_debug_message("Host hash: " + host_hash);
        show_debug_message("Local hash: " + local_hash);
		
		if resync_attempt_count < 1 {
			// If a one time occurance, let predictions correct themselves
			if verbose {
				show_debug_message("Waiting for second hash check...");
			}
			resync_attempt_count++;
		} else if resync_attempt_count < max_total_resync_attempts {
			if verbose {
				show_debug_message("Hash check failed, requesting state correction from host");
			}
			// If infrequent, do minor state corrections
			request_state_correction();	
		} else {
			// If frequent, request a full resync
			request_full_resync();
		}
        
    }
}