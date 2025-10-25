if highlight {
	image_alpha = 1;
	if clicked {
		camera_set_view_pos(view_camera[0],0,room_height);
		audio_stop_sound(snd_page_turn);
		audio_play_sound(snd_page_turn,0,0);		
		clicked = false;
	}
} else {
	image_alpha = .3;
}
