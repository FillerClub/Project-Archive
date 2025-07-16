if (input_check("action") && position_meeting(obj_cursor.x,obj_cursor.y,self)) {
	timer += delta_time*DELTA_TO_SECONDS;
	if timer >= 5 {
		with obj_generic_hero {
			if team == global.player_team {
				hp = 0;	
			}
		}
	}
} else {
	timer = 0;
}
