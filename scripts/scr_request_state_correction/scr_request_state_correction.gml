function request_state_correction() {
    resync_attempt_count++
	var packet = {
        Message: SEND.STATE_CHECK,
        player_id: obj_preasync_handler.steam_id
    };
	
	steam_relay_data(packet)
}

