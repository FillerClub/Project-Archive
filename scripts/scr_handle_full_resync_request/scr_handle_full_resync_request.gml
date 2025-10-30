function handle_full_resync_request(packet) {
    show_debug_message("Client requested FULL RESYNC");
    
    // Capture complete save state
    var full_state = create_save_state();
    var timeStamp = 0;
	with obj_battle_handler {
		timeStamp = get_timer() -game_clock_start;	
	}
	
    var resync_packet = {
        Message: SEND.FULL_RESYNC,
        time_stamp: timeStamp,
        state_data: full_state
    };
    
    show_debug_message("Sending full state to client");
    
	// Send to requesting client
    send_packet_to_client(packet.player_id,resync_packet);
}