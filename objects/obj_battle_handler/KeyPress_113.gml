if global.debug {
	if instance_exists(obj_world_one) {
		with obj_world_one {
			timer += 100;	
		}
	}
	if instance_exists(obj_generic_piece) {
		with obj_generic_piece {
			if team != global.player_team {
				instance_destroy();	
			}
		}
	}
	if instance_exists(obj_timer) {
		timer[MAIN] += global.timeruplength;
	}
}
