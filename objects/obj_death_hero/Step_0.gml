
expire += delta_time*DELTA_TO_SECONDS/2;
if !audio_is_playing(snd_game_end) && expire >= 4.5 {
	instance_destroy();	
	room_goto(rm_main_menu);
}