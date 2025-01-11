function drop_slot(drop_phase,drop_identity,level_progress,drop_boolean = true,unlocks_hero = false){
	if pause_sequence(drop_phase,drop_boolean,0) {
		instance_create_layer(last_piece_x,last_piece_y,"AboveBoard",obj_dropped_slot,{
			identity: drop_identity,
			hero_unlock: unlocks_hero,
		});
		display_identity = drop_identity;
		new_level = level_progress;
	}
}