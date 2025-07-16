if update {
	with obj_server_manager {
		// Write updated rules
		buffer_seek(send_buffer, buffer_seek_start,0);
		buffer_write(send_buffer, buffer_u8,SEND.MATCHDATA);
		write_all_gamerule_data(send_buffer,other.max_slots,other.show_opponent_slots,other.barrier_criteria,other.timeruplength,other.max_pieces,other.map);
		buffer_write(send_buffer, buffer_u8,DATA.END);
		// Send buffer to opponent, since host already dictated rules
		if other.opponent_port != -1 {
			network_send_udp(socket,other.opponent_ip,other.opponent_port,send_buffer,buffer_tell(send_buffer));
		}
	}
	update = false;
}	

if host_ready && opponent_ready {
	ready_timer += delta_time*DELTA_TO_SECONDS;
	if ready_timer >= 1 {
		var hostP = host_port,
		hostIP = host_ip,
		opponentP = opponent_port,
		opponentIP = opponent_ip;
		seed = irandom(4294967295);
		with obj_server_manager {
			var host = undefined,
			opponent = undefined;
			for (var i = 0; i < array_length(players); i++) {
				if players[i].port == hostP {
					host = players[i];
				}
				if players[i].port == opponentP {
					opponent = players[i];
				}
			}
			if host == undefined || opponent == undefined {
				exit;
			}	
			if other.show_opponent_slots {
				buffer_seek(send_buffer, buffer_seek_start,0);
				buffer_write(send_buffer, buffer_u8,SEND.MATCHDATA);
				write_data_buffer(send_buffer,DATA.LOADOUT,host.loadout);
				buffer_write(send_buffer, buffer_u8,DATA.END);
				network_send_udp(socket,opponentIP,opponentP,send_buffer,buffer_tell(send_buffer));
				buffer_seek(send_buffer, buffer_seek_start,0);
				buffer_write(send_buffer, buffer_u8,SEND.MATCHDATA);
				write_data_buffer(send_buffer,DATA.LOADOUT,opponent.loadout);
				buffer_write(send_buffer, buffer_u8,DATA.END);
				network_send_udp(socket,hostIP,hostP,send_buffer,buffer_tell(send_buffer));
			}
			buffer_seek(send_buffer, buffer_seek_start,0);
			buffer_write(send_buffer, buffer_u8,SEND.READY);
			buffer_write(send_buffer, buffer_u32,other.seed);
			network_send_udp(socket,hostIP,hostP,send_buffer,buffer_tell(send_buffer));
			network_send_udp(socket,opponentIP,opponentP,send_buffer,buffer_tell(send_buffer));
			host.status = ONLINESTATUS.INGAME;
			opponent.status = ONLINESTATUS.INGAME;
		}
		host_ready = -1;
		opponent_ready = -1;
		ready_timer = 0;
	}
}
var len = array_length(requests);
if len > 0 {
	var hostP = host_port,
	hostIP = host_ip,
	opponentP = opponent_port,
	opponentIP = opponent_ip,
	read = array_shift(requests),
	struct = json_stringify(read);
	with obj_server_manager {
		buffer_seek(send_buffer,buffer_seek_start,0);
		buffer_write(send_buffer,buffer_u8,SEND.GAMEDATA);
		buffer_write(send_buffer,buffer_string,struct);
		switch read.action {
			// Generate tags for new pieces
			case DATA.SPAWN:
				buffer_write(send_buffer,buffer_u8,other.tag_assign);
				other.tag_assign++;
			break;
		}
		network_send_udp(socket,hostIP,hostP,send_buffer,buffer_tell(send_buffer));	
		network_send_udp(socket,opponentIP,opponentP,send_buffer,buffer_tell(send_buffer));	
	}
	if tag_assign > 255 {
		tag_assign = 0;
	}	
} 