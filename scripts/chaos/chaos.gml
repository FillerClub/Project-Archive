function toggle_chaos_mode() {
    static chaos_active = false;
    chaos_active = !chaos_active;
    
    if (chaos_active) {
        log_debug("CHAOS MODE: Activated", c_red);
        // Create timer for random chaos events
        chaos_timer = call_later(60, time_source_units_frames, chaos_event, true);
    } else {
        log_debug("CHAOS MODE: Deactivated", c_green);
        if (variable_instance_exists(id, "chaos_timer")) {
            call_cancel(chaos_timer);
        }
    }
}

function chaos_event() {
    var chaos_type = irandom(4);
    
    switch (chaos_type) {
        case 0: // Random lag spike
            sim_lag = random_range(100, 500);
            call_later(180, time_source_units_frames, function() { sim_lag = 0; });
            log_debug("CHAOS: Lag spike!", c_red);
            break;
            
        case 1: // Packet loss burst
            sim_packet_loss = random_range(20, 50);
            call_later(120, time_source_units_frames, function() { sim_packet_loss = 0; });
            log_debug("CHAOS: Packet loss burst!", c_red);
            break;
            
        case 2: // Force minor desync
            force_artificial_desync();
            break;
            
        case 3: // Rapid actions
            repeat(irandom_range(3, 8)) {
                simulate_rapid_action();
            }
            log_debug("CHAOS: Action spam!", c_yellow);
            break;
            
        case 4: // Time dilation
            game_set_speed(random_range(30, 120), gamespeed_fps);
            call_later(240, time_source_units_frames, function() { 
                game_set_speed(60, gamespeed_fps); 
            });
            log_debug("CHAOS: Time dilation!", c_purple);
            break;
    }
}

function simulate_rapid_action() {
    // Simulate player spamming actions
    var random_action = {
        Message: SEND.GAMEDATA,
        action: "Move",
        tag: "debug_piece_" + string(irandom(10)),
        grid_pos: [irandom(8), irandom(8)],
        piece_on_grid: obj_board,
        prediction_id: generate_prediction_id()
    };
    
    // Send without prediction to test spam handling
    steam_relay_data_debug(random_action);
}