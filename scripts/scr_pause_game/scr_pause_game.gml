function pause_game(unpause = false) {
	var gameInst = noone;
	with obj_game {
		gameInst = id;
	}
	if !gameInst.enable_pausing  {
		exit;	
	}
	
	if unpause {
		if global.pause && gameInst.on_pause_menu {
			audio_stop_sound(snd_pause);
			audio_play_sound(snd_unpause,0,0);	
			time_source_resume(time_source_game);
			global.pause = false;	
			gameInst.on_pause_menu = false;
		}
	} else {
		if !global.pause && !gameInst.on_pause_menu {
			audio_stop_sound(snd_unpause);
			audio_play_sound(snd_pause,0,0);	
			time_source_pause(time_source_game);
			global.pause = true;	
			gameInst.on_pause_menu = true;
		}
	}
}