x = obj_cursor.x;
y = obj_cursor.y;
if input_check_released("action") {
	var destroyDrag = false;
	if position_meeting(x,y,obj_loadout_slot) {
		destroyDrag = true;
		with instance_position(x,y,obj_loadout_slot) {
			identity = other.identity;	
		}
	}
	if position_meeting(x,y,obj_unlocked_slot) {
		//destroyDrag = true;
	}
	
	if destroyDrag {
		audio_stop_sound(snd_put_down);
		audio_play_sound(snd_put_down,0,0);
		instance_destroy();	
	}
}