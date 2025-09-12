event_inherited();

// shoot
if global.game_state != PAUSED {
	if (timer >= timer_end) {
		var shootTop = scan_for_enemy(false,100,false,1,x,y -GRIDSPACE),
		shootBottom = scan_for_enemy(false,100,false,1,x,y +GRIDSPACE),
		shootMid = scan_for_enemy(true,100,false,1,x,y),
		hasShot = false,
		zOff = z;
		if shootTop && shootBottom {
			shootMid = false;	
		}
		
		if repeat_shot <= 0 {
			repeat_shot = 2;

		} 
		
		if repeat_shot > 1 {
			timer = timer_end*.95;	
		}
		var gridOff = piece_on_grid;
		if is_string(gridOff) {
			with obj_grid {
				if tag == gridOff {
					zOff += z;
					break;
				}
			}
		} else if instance_exists(gridOff) { zOff += gridOff.z; }
		if shootTop && repeat_shot == 2 {
			instance_create_depth(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2 +random_range(-4,4) -GRIDSPACE,depth -GRIDSPACE/2,obj_bullet_parent, {
			team: team,	
			x_vel: ((team == "friendly")?1:-1),
			z: zOff,
			});				
		}
		if shootMid && repeat_shot != 2 {
			instance_create_depth(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2 +random_range(-4,4),depth -GRIDSPACE/2,obj_bullet_parent, {
			team: team,	
			x_vel: ((team == "friendly")?1:-1),
			z: zOff,
			});				
		}
		if shootBottom && repeat_shot != 2 {
			instance_create_depth(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2 +random_range(-4,4) +GRIDSPACE,depth -GRIDSPACE/2,obj_bullet_parent, {
			team: team,	
			x_vel: ((team == "friendly")?1:-1),
			z: zOff,
			});				
		}
		if shootBottom || shootMid || shootTop {
			repeat_shot -= 1;
			timer = 0;
			timer_end = random_percent(1.4,4);			
		}
	}
}
