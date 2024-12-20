if global.debug {
	if instance_exists(obj_world_one) {
		with obj_world_one {
			timer += 100;	
		}
	}
	if instance_exists(obj_generic_piece) {
		with obj_generic_piece {
			if team != global.team && object_get_parent(object_index) != obj_generic_hero_OLD {
				instance_destroy();	
			}
		}
	}
	if instance_exists(obj_timer) {
		timer[MAIN] = 30;
	}
}