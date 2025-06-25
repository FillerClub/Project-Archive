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

