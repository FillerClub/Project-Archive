if game_status != ONLINESTATUS.IDLE	&& room == rm_lobby {
	global.team = "friendly";
	global.enemy_team = "enemy";
	global.max_slots = 6;
	global.barrier_criteria = 4;
	global.max_pieces = infinity;
	global.timeruplength = 30;
	game_status = ONLINESTATUS.IDLE;
	buffer_seek(send_buffer,buffer_seek_start,0);
	buffer_write(send_buffer,buffer_u8,SEND.DATA);
	write_all_player_data(send_buffer,global.name,game_status,global.active_hero,global.loadout);
	buffer_write(send_buffer,buffer_u8,REMOTEDATA.END);
	network_send_udp(socket,server_ip,server_port,send_buffer,buffer_tell(send_buffer));	
	create_system_message(["Successfullly connected!"],BOTTOM);	
}



