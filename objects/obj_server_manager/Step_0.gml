if running_matches <= 0 {
	match_index = 0;	
}
x = match_index*1280 -1280 +oX;
if keyboard_check(vk_escape) {
	exit_timer += delta_time*DELTA_TO_SECONDS;
} else {
	exit_timer = 0;
}	

if exit_timer >= 2 {
	game_end();	
}
var arPlay = array_length(players);
if update_players {
	// Write current player list
	for (var u = 0; u < arPlay; u++) {
		buffer_seek(send_buffer, buffer_seek_start,0);
		buffer_write(send_buffer, buffer_u8,SEND.DATA);
		write_data_buffer(send_buffer,REMOTEDATA.PORT,players[u].port);
		write_data_buffer(send_buffer,REMOTEDATA.STATUS,players[u].status);
		write_data_buffer(send_buffer,REMOTEDATA.NAME,players[u].name);
		write_data_buffer(send_buffer,REMOTEDATA.HERO,players[u].hero);
		write_data_buffer(send_buffer,REMOTEDATA.LOADOUT,players[u].loadout);
		buffer_write(send_buffer, buffer_u8,REMOTEDATA.END);
		// Send buffer to everyone
		for (var uu = 0; uu < arPlay; uu++) {
			if players[uu].status != ONLINESTATUS.IDLE {
				continue;
			}
			network_send_udp(socket,players[uu].ip,players[uu].port,send_buffer,buffer_tell(send_buffer));
		}
		// Update object
		with players[u].object {
			player = other.players[u];	
		}
	}
	update_players = false;
}	