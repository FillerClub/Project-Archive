function steam_relay_message(Message) { // Sent From Client
	var Data = {Message : Message}
	var json = json_stringify(Data);
	var buff = buffer_create(string_byte_length(json), buffer_fixed, 1);
	buffer_write(buff, buffer_text, json);
	steam_net_packet_send(steam_lobby_get_owner_id(),buff);
	buffer_delete(buff);
	return;
}

function steam_relay_data(Buffer) { // Sent From Client
	// Debugging tools
	var verbose = global.verbose_debug;
	var json = json_stringify(Buffer);
	var lobbyOwner = steam_lobby_get_owner_id();
	with obj_debugger {
	    if !simulate_lag {
			var buff = buffer_create(string_byte_length(json), buffer_fixed, 1);
			buffer_write(buff, buffer_text, json);
			steam_net_packet_send(lobbyOwner,buff);
			buffer_delete(buff);			
	        return;
	    }
		if random(100) < packet_loss_percent {
			if verbose {
			    show_debug_message("[SIM] Packet dropped (loss simulation)");
			}
		    return;
	    }
		// Add artificial delay
		var delivery_time = current_time +(artificial_lag_ms);
		ds_priority_add(packet_queue, {
	        target: lobbyOwner,
	        data: json,
			time_stamp: delivery_time,
	    }, delivery_time);
    
	    if verbose {
	        show_debug_message("[SIM] Packet queued for +" + string(artificial_lag_ms) + "ms delay");
	    }
		return
	}
	// Incase doesn't go through debugger	
	var buff = buffer_create(string_byte_length(json), buffer_fixed, 1);
	buffer_write(buff, buffer_text, json);
	steam_net_packet_send(lobbyOwner,buff);
	buffer_delete(buff);		
	return;
}

function steam_bounce(Buffer) {
	// Debugging tools
	var verbose = global.verbose_debug;
	var json = json_stringify(Buffer);

	with obj_debugger {
	    if !simulate_lag {
			var buff = buffer_create(string_byte_length(json), buffer_fixed, 1);
			buffer_write(buff, buffer_text, json);		
			for(var i = 0; i < steam_lobby_get_member_count(); i++) {
				var MemberID = steam_lobby_get_member_id(i);
				steam_net_packet_send(MemberID,buff);
			}
			buffer_delete(buff);
			return;
	    }
		if random(100) < packet_loss_percent {
			if verbose {
			    show_debug_message("[SIM] Packet dropped (loss simulation)");
			}
		    return;
	    }
		// Add artificial delay
		var delivery_time = current_time +(artificial_lag_ms * 1000);
		
		for(var i = 0; i < steam_lobby_get_member_count(); i++) {
			var MemberID = steam_lobby_get_member_id(i);
			ds_priority_add(packet_queue, {
		        target: MemberID,
		        data: json,
		    }, delivery_time);
		}

	    if verbose {
	        show_debug_message("[SIM] Packet queued for +" + string(artificial_lag_ms) + "ms delay");
	    }
		return
	}
	// Incase doesn't go through debugger	
	var buff = buffer_create(string_byte_length(json), buffer_fixed, 1);
	buffer_write(buff, buffer_text, json);		
	for(var i = 0; i < steam_lobby_get_member_count(); i++) {
		var MemberID = steam_lobby_get_member_id(i);
		steam_net_packet_send(MemberID,buff);
	}
	buffer_delete(buff);	
	return;
}
function send_packet_to_client(target_client_id, packet) {
	// Debugging tools
	var verbose = global.verbose_debug;
	var json = json_stringify(packet);
	with obj_debugger {
	    if !simulate_lag {
			var buff = buffer_create(string_byte_length(json), buffer_fixed, 1);
			buffer_write(buff, buffer_text, json);
			steam_net_packet_send(target_client_id,buff);
			buffer_delete(buff);			
	        return;
	    }
		if random(100) < packet_loss_percent {
			if verbose {
			    show_debug_message("[SIM] Packet dropped (loss simulation)");
			}
		    return;
	    }
		// Add artificial delay
		var delivery_time = current_time +(artificial_lag_ms * 1000);
		ds_priority_add(packet_queue, {
	        target: target_client_id,
	        data: json,
	    }, delivery_time);
    
	    if verbose {
	        show_debug_message("[SIM] Packet queued for +" + string(artificial_lag_ms) + "ms delay");
	    }
		break;
	}
	// Incase doesn't go through debugger	
	var buff = buffer_create(string_byte_length(json), buffer_fixed, 1);
	buffer_write(buff, buffer_text, json);
	steam_net_packet_send(target_client_id,buff);
	buffer_delete(buff);		
	return;
}