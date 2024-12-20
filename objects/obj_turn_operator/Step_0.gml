if time_source_get_state(error_time) == time_source_state_stopped {
	draw_blue_green = 1;
}

if input_check_pressed("action") && position_meeting(obj_cursor.x,obj_cursor.y,self) {
	if obj_cursor.y > y {
		if team == "friendly" {
			global.turns -= 1;
		}
		if team == "enemy" {
			global.enemy_turns -= 1;
		}
	
	} else if obj_cursor.y < y {
		if team == "friendly" {
			global.turns += 1;
		}
		if team == "enemy" {
			global.enemy_turns += 1;
		}
	}
}