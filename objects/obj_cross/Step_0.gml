event_inherited();

if timer >= .5 {
	var backwards = tm_dp(-1,team);
	for (var i = 1; position_meeting(x +i*GRIDSPACE*backwards,y,obj_grid); i++) {
		with instance_position(x +i*GRIDSPACE*backwards,y,obj_generic_piece) {
			if team == other.team {
				effect_give(EFFECT.SPEED,.5,2);	
			}
		}
	}
	timer -= .5;
}
