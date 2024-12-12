function select_sound(action, cancel_sound = true){
	if cancel_sound {
		audio_stop_sound(snd_pick_up);
		audio_stop_sound(snd_put_down);
	}
	audio_play_sound(action,0,0);
}