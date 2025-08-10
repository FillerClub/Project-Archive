event_inherited();

// shoot
if global.game_state != PAUSED{
	var gS = GRIDSPACE;
	if (timer >= timer_end) {
		repeat_shot -= 1;
		timer = 0;
		timer_end = random_percent(1.4,4);
		
		if repeat_shot <= 0 {
			repeat_shot = 2;

		} 
		
		if repeat_shot > 1 {
			timer = timer_end*.95;	
		}
		
		if scan_for_enemy() {
			var zOff = z;
			if instance_exists(piece_on_grid) {
				zOff += piece_on_grid.z;	
			}
			instance_create_depth(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2 +random_range(-4,4),depth -gS/2,obj_bullet_parent, {
			team: team,	
			x_vel: ((team == "friendly")?1:-1),
			z: zOff,
			});

		}
	}
}
