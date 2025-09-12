function steam_relay_data_debug(packet) {
    if (!instance_exists(obj_debugger)) {
        steam_relay_data(packet);
        return;
    }
    
    with (obj_debugger) {
        // Simulate packet loss
        if (sim_packet_loss > 0) {
            if (random(100) < sim_packet_loss) {
                log_debug("SIMULATED: Packet dropped", c_red);
                return; // Drop packet
            }
        }
        
        // Simulate lag and jitter
        var delay = sim_lag;
        if (sim_jitter > 0) {
            delay += random_range(-sim_jitter, sim_jitter);
        }
        
        if (delay > 0) {
            // Store packet for delayed sending
            var delayed_packet = {
                packet: packet,
                send_time: get_timer() + (delay * 1000) // Convert ms to microseconds
            };
            
            if (!variable_instance_exists(id, "delayed_packets")) {
                delayed_packets = [];
            }
            
            array_push(delayed_packets, delayed_packet);
            log_debug("SIMULATED: Delayed packet by " + string(delay) + "ms", c_yellow);
        } else {
            steam_relay_data(packet);
        }
    }
}

// Process delayed packets
function process_delayed_packets() {
    if (!variable_instance_exists(id, "delayed_packets")) return;
    
    var currentTime = get_timer();
    
    for (var i = array_length(delayed_packets) - 1; i >= 0; i--) {
        var delayed = delayed_packets[i];
        
        if (currentTime >= delayed.send_time) {
            steam_relay_data(delayed.packet);
            array_delete(delayed_packets, i, 1);
            log_debug("SIMULATED: Sent delayed packet", c_lime);
        }
    }
}