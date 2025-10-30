function send_hash_check() {
    var state_hash = calculate_state_hash(),
    packet = {
        Message: SEND.HASH_CHECK,
        hash: state_hash,
    };
	
    if global.verbose_debug {
        show_debug_message("Sending hash check: " + state_hash);
    }
    steam_bounce(packet);
}