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