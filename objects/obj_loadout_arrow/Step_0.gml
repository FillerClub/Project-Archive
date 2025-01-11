if position_meeting(obj_cursor.x,obj_cursor.y,self) && input_check_pressed("action") {
	with obj_hero_display {
		index += other.dir;	
	}
	audio_play_sound(snd_error,0,0);
}