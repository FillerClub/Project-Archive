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
if update_players {
	// Clear self from list before updating
	for (var i = 0; i < array_length(players); i++) {
		if players[i].port == port {
			array_delete(players,i,1);
			i--;
		}
	}
	var list = obj_player_list;
	list.player = [];
	list.status = [];
	for (var ii = 0; ii < array_length(players); ii++) {
		list.player[ii] = players[ii].name;
		list.status[ii] = players[ii].status;
	}
	update_players = false;
}
