if timeout >= 0 {
	timeout += delta_time*DELTA_TO_SECONDS;
}
if timeout >= 10 && connection_status == -1 {
	audio_play_sound(snd_critical_error,0,0);
	instance_create_layer(room_width,0,"GUI",obj_plain_text_box, {
		text: "Failed to connect to server."
	});
	with obj_menu {
		progress_menu(-1);	
	}
	instance_destroy();
}
if connection_status {
	ping_timer += delta_time*DELTA_TO_SECONDS;
	if ping_timer >= .8 && ping_send {
		//audio_stop_sound(snd_critical_error);
		//audio_play_sound(snd_critical_error,0,0);
		ping_past_time = current_time;
		buffer_seek(send_buffer,buffer_seek_start,0);
		buffer_write(send_buffer,buffer_u8,SEND.PING);
		network_send_udp(socket,server_ip,server_port,send_buffer,buffer_tell(send_buffer));	
		ping_timer = 0;	
		ping_send = false;
	}	
}
if update_players {
	// Clear self from list before updating
	for (var i = 0; i < array_length(players); i++) {
		if players[i].network_id == network_id {
			array_delete(players,i,1);
			i--;
		}
	}
	var list = obj_player_list;
	list.player = [];
	list.status = [];
	list.network_id = [];
	for (var ii = 0; ii < array_length(players); ii++) {
		list.player[ii] = players[ii].name;
		list.status[ii] = players[ii].status;
		list.network_id[ii] = players[ii].network_id;
	}
	update_players = false;
}
