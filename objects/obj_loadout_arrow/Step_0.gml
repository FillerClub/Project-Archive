if instance_exists(obj_ready) {
	if obj_ready.ready {
		exit;	
	}
}

if position_meeting(obj_cursor.x,obj_cursor.y,self) && input_check_pressed("action") {
	with obj_hero_display {
		index += other.dir;	
		update = true;
	}
	audio_play_sound(snd_error,0,0);
}