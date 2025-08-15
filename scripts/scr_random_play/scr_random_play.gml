function audio_play_from_array(sound_array, random_pitch = .15,stop_previous_sounds = false){
	var	audioLen = array_length(sound_array);
	if stop_previous_sounds {
		for (var a = 0; a < audioLen; a++) {
			audio_stop_sound(sound_array[a]);
		}
	}
	var final_sound = {
		sound: sound_array[irandom(audioLen -1)],
		pitch: random_range(1 -random_pitch,1 +random_pitch),
	};
	audio_play_sound_ext(final_sound);
}