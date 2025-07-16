if game_status != ONLINESTATUS.IDLE	&& room == rm_lobby {
	default_game_rules();
	game_status = ONLINESTATUS.IDLE;
	buffer_seek(send_buffer,buffer_seek_start,0);
	buffer_write(send_buffer,buffer_u8,SEND.MATCHDATA);
	write_all_player_data(send_buffer,global.name,game_status,global.active_hero,global.loadout);
	buffer_write(send_buffer,buffer_u8,DATA.END);
	network_send_udp(socket,server_ip,server_port,send_buffer,buffer_tell(send_buffer));	
	create_system_message(["Successfullly connected!"],BOTTOM);	
}

if room == rm_loadout_zone_multiplayer {
	shift_hero_displays()
}

