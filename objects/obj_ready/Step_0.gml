if position_meeting(obj_cursor.x,obj_cursor.y,self) {
	if input_check_pressed("action") {
		ready = ready?false:true;
		audio_play_sound(snd_timer_cycle,0,0);
		var structSend = {Message: SEND.MATCHDATA},
		playerString = "",
		userID = obj_preasync_handler.steam_id,
		player1 = steam_lobby_get_data("Player1"),
		player2 = steam_lobby_get_data("Player2");
		with obj_loadout_slot {
			if player == 1 && player1 == userID {
				playerString = "Player1Ready";
			}
			if player == 2 && player2 == userID {
				playerString = "Player2Ready";
			}
		}
		
		if playerString != "" {
			struct_set(structSend,playerString,ready);
			steam_bounce(structSend);
		}
	}
}