function initiate_final_wave(phase, boolean = true, audio_track_raise = track4){
	if pause_sequence(phase,boolean,3) {
		graphic_show = FINALWAVE;
		time_source_start(graphic_timer);
		audio_group_set_gain(audio_track_raise,1,4500);
	}
}