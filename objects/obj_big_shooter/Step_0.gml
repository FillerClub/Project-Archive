event_inherited();

if execute = "move" || ai_controlled { 
	valid_moves = piece_database(identity,PIECEDATA.MOVES);
	queen_move_handler(BOTH);
}

if !global.pause {
	var gS = GRIDSPACE;
	if (timer >= timer_end) {
		repeat_shot -= 1;
		timer -= timer_end;
		
		if repeat_shot <= 0 {
			repeat_shot = repeat_shot_base;

		} 
		
		if repeat_shot > 1 {
			timer = timer_end*.95;	
		}
		
		if scan_for_enemy() {
			instance_create_depth(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2 +random_range(-4,4),depth -gS/2,obj_bullet_parent, {
			team: team,	
			dmg: damage,
			x_vel: ((team == "friendly")?1:-1),
			});
		}
	}
}
