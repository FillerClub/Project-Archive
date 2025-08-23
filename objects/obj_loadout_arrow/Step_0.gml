if instance_exists(obj_ready) {
	active = false;
	// Online behavior
	if obj_ready.ready {
		exit;	
	}	
	var player1 = steam_lobby_get_data("Player1"),
	player2 = steam_lobby_get_data("Player2");
	// Determine which player we are
	if obj_preasync_handler.steam_id == player1 && player == 1 {
		active = true;
	}
	if obj_preasync_handler.steam_id == player2 && player == 2 {
		active = true;
	}
	if !active {
		exit;
	}
}
if position_meeting(obj_cursor.x,obj_cursor.y,self) && input_check_pressed("action") {
	with obj_hero_display {
		if player == other.player {
			index += other.dir;	
			update = true;
		}
	}
	audio_play_sound(snd_error,0,0);
}