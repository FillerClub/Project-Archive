function handle_state_correction(packet) {
    var verbose = global.verbose_debug;
	if verbose {
        show_debug_message("Receiving state correction from host");
        show_debug_message(string(packet));
		show_debug_message(string(packet.time_stamp));
    }
	// Reverify hash (check if it's a fluke)
	if variable_struct_exists(packet, "hash") {
	    var local_hash = calculate_state_hash();
	    var host_hash = packet.hash;
    
		// Continue if hashes are still mismatched
	    if local_hash == host_hash {
	        if global.verbose_debug {
	            show_debug_message("Hash verified: " + local_hash);
	            show_debug_message("Skipping state correction");
	        }
			return false;
	    }
	}
	
    // Apply corrections
    if variable_struct_exists(packet, "globals") {
        load_globals(packet.globals,SAVEGLOBALS);	
        if verbose {
            show_debug_message("Updated resources");
        }
    }

	var timeStamp = 0;
	if variable_struct_exists(packet, "time_stamp") {
		timeStamp = packet.time_stamp;	
	}
    if variable_struct_exists(packet, "objects") {
        correct_objects(packet.objects,timeStamp);
		if verbose {
            show_debug_message("Updated instances");
        }
    }
	// Afterwards, rely on hash checks to ensure game is in sync
}
