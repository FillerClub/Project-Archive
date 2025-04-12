var gS = GRIDSPACE;
event_inherited();

// shoot
if global.game_state != PAUSED{
	if (timer >= timer_end) {
		repeat_shot -= 1;
		timer = 0;
		timer_end = random_percent(2.6,10);
		
		if repeat_shot <= 0 {
			repeat_shot = 2
		} 
		
		if repeat_shot > 1 {
			timer = timer_end*.8;	
		}




		if scan_for_enemy(true,4) {
			var 
			spread_reduce = .25,
			rand = 0;
			repeat 12 {
				rand = random_range(-16,16);
				instance_create_depth(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2 +random_range(-4,4),depth -gS/2,obj_bullet_parent, {
				image_xscale: .5,
				image_yscale: .5,
				team: team,	
				x_vel: ((team == "friendly")?1:-1)*(1 -abs(rand/16)*spread_reduce),
				y_vel: spread_reduce*rand/16,
				falloff_dist: 64*1.5,
				});
			}
		}	
	}
}

