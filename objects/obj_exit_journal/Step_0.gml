if position_meeting(obj_cursor.x,obj_cursor.y,self) && input_check_pressed("action") {
	camera_set_view_pos(view_camera[0],0,0);
	audio_stop_sound(snd_page_turn);
	audio_play_sound(snd_page_turn,0,0);
}