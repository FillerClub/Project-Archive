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
		buffer_write(send_buffer, buffer_u8,SEND.MATCHDATA);
		write_data_buffer(send_buffer,DATA.PORT,players[u].port);
		write_data_buffer(send_buffer,DATA.STATUS,players[u].status);
		write_data_buffer(send_buffer,DATA.NAME,players[u].name);
		write_data_buffer(send_buffer,DATA.HERO,players[u].hero);
		// Keep loadout data hidden
		// write_data_buffer(send_buffer,REMOTEDATA.LOADOUT,players[u].loadout);
		buffer_write(send_buffer, buffer_u8,DATA.END);
		// Send buffer to everyone
		for (var uu = 0; uu < arPlay; uu++) {
			network_send_udp(socket,players[uu].ip,players[uu].port,send_buffer,buffer_tell(send_buffer));
		}
		// Update object
		with players[u].object {
			player = other.players[u];	
		}
	}
	update_players = false;
}	