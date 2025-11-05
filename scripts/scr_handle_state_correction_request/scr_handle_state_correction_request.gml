function handle_correction_request(packet) {
	var verbose = global.verbose_debug;
	var stateHash = calculate_state_hash();
	// Resend state hash in case of fluke
	
	if verbose {
        show_debug_message("Client requested state correction");
	}
	
    var timestamp = 0;
	with obj_battle_handler {
		timestamp = get_timer() -game_clock_start;	
	}
    // Capture current state details
    var correction_data = {
        Message: SEND.STATE_CHECK,
		hash: stateHash,
        time_stamp: timestamp,
        globals: capture_globals(SAVEGLOBALS),
        objects: capture_object_data(SHORTSAVEOBJECTS,SHORTSAVEOBJECTVARIABLES),
    };
	
    if verbose {
        show_debug_message("Sending state correction to client");
    }
    // Send to requesting client
    send_packet_to_client(packet.player_id,correction_data);
}