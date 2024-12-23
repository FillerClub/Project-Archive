event_inherited();

// shoot
if !global.pause {
	var gS = global.grid_spacing;
	if (timer >= timer_end) {
		repeat_shot -= 1;
		timer = 0;
		timer_end = 1.8*random_range(0.95,1.05);
		
		if repeat_shot <= 0 {
			repeat_shot = 2;

		} 
		
		if repeat_shot > 1 {
			timer = timer_end*.95;	
		}
		
		if scan_for_enemy() {
			instance_create_depth(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2 +random_range(-4,4),depth -gS/2,obj_bullet_parent, {
			team: team,	
			x_vel: ((team == "friendly")?1:-1),
			});
		}
	}
}
