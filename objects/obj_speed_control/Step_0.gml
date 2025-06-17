
if (input_check_pressed("action") && position_meeting(obj_cursor.x,obj_cursor.y,self)) || input_check_pressed("fast_forward") {
	with obj_battle_handler {
		if speed_factor != 1 {
			speed_factor = 1;	
			change_in_speed = true;
			other.at_max = false;
		} else if speed_factor != 2 {
			speed_factor = 2
			change_in_speed = true;
			other.at_max = true;
		}
	}
}	
