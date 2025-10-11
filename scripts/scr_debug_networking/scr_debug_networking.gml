function force_artificial_desync() {
    log_debug("FORCED: Creating artificial desync", c_red);
    
    // Randomly modify local state to create desync
    with (obj_generic_piece) {
		if random(100) < 5 {
			instance_destroy();	
		}        
		if random(100) <= 30 { // 30% chance per piece
            hurt(hp,random(5),DAMAGE.NORMAL,self);
			heal(hp,hp_max,random(5),true);
            grid_pos[0] += irandom_range(-16, 16);
            grid_pos[1] += irandom_range(-16, 16);
            break;
        }
    }
    
    global.friendly_turns += irandom_range(-2, 2);
    desync_count++;
}

function cycle_network_simulation() {
    static sim_mode = 0;
    sim_mode = (sim_mode + 1) % 5;
    
    switch (sim_mode) {
        case 0: // Normal
            sim_lag = 0; sim_packet_loss = 0; sim_jitter = 0;
            log_debug("SIMULATION: Normal network", c_green);
            break;
        case 1: // High lag
            sim_lag = 200; sim_packet_loss = 0; sim_jitter = 50;
            log_debug("SIMULATION: High lag (200ms +/- 50ms)", c_yellow);
            break;
        case 2: // Packet loss
            sim_lag = 50; sim_packet_loss = 10; sim_jitter = 20;
            log_debug("SIMULATION: Packet loss (10%)", c_orange);
            break;
        case 3: // Extreme conditions
            sim_lag = 300; sim_packet_loss = 20; sim_jitter = 100;
            log_debug("SIMULATION: Extreme conditions", c_red);
            break;
        case 4: // Jittery
            sim_lag = 100; sim_packet_loss = 5; sim_jitter = 150;
            log_debug("SIMULATION: High jitter", c_purple);
            break;
    }
}