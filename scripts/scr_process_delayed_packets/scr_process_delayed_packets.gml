function process_delayed_packets(delay) {
    // Process packets whose time has come
    var currentTime = current_time;
    with obj_debugger {
	    while !ds_priority_empty(packet_queue) {
	        var delivery_time = ds_priority_find_min(packet_queue);
        
	        if currentTime >= delivery_time.time_stamp || !delay {
	            var packet_info = ds_priority_delete_min(packet_queue);
            
	            // Actually send the packet now'
				var buff = buffer_create(string_byte_length(packet_info.data), buffer_fixed, 1);
				buffer_write(buff, buffer_text, packet_info.data);
				steam_net_packet_send(packet_info.target,buff);
				buffer_delete(buff);	
            
	            if global.verbose_debug {
	                show_debug_message("[SIM] Delayed packet delivered");
	            }
	        } else {
	            break;
	        }
	    }
	}
}