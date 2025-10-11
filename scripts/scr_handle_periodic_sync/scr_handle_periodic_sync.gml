function handle_periodic_sync() {
    var sync_packet = {};
    var needs_send = false;
    
    // Check if we need to send any sync data this tick
    /*
	if (tick_count % 300 == 0) { // Every 5 seconds
        sync_packet = {Message: SEND.PERIODIC_SYNC, tick: tick_count};
        sync_packet.full_state = create_save_state();
		sync_packet.timestamp = get_timer();
        needs_send = true;
        //audio_play_sound(snd_timer_upgrade, 0, 0);
    } else */
	/*
	if (tick_count % 180 == 0) { // Every 3 seconds
        sync_packet = {Message: SEND.PERIODIC_SYNC, tick: tick_count};
        sync_packet.detailed_state = capture_detailed_state();
        needs_send = true;
        //audio_play_sound(snd_shield_up, 0, 0);
    } else */
	if (tick_count % 30 == 0) { // Every half second
        sync_packet = {
            Message: SEND.PERIODIC_SYNC,
            tick: tick_count,
            state_hash: calculate_state_hash()
        };
        needs_send = true;
        //audio_play_sound(snd_timer_cycle, 0, 0);
    }
     
    if (needs_send) {
        steam_bounce(sync_packet);
    }
}