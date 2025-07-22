event_inherited();

// shoot
if global.game_state != PAUSED{
	if (timer >= timer_end) {
		var shootTop = scan_for_enemy(false,100,x,y -GRIDSPACE),
		shootBottom = scan_for_enemy(false,100,x,y +GRIDSPACE),
		shootMid = scan_for_enemy(true,100,x,y),
		hasShot = false;
		if shootTop && shootBottom {
			shootMid = false;	
		}
		
		if repeat_shot <= 0 {
			repeat_shot = 2;

		} 
		
		if repeat_shot > 1 {
			timer = timer_end*.95;	
		}
		
		if shootTop && repeat_shot == 2 {
			instance_create_depth(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2 +random_range(-4,4) -GRIDSPACE,depth -GRIDSPACE/2,obj_bullet_parent, {
			team: team,	
			x_vel: ((team == "friendly")?1:-1),
			});				
		}
		if shootMid && repeat_shot != 2 {
			instance_create_depth(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2 +random_range(-4,4),depth -GRIDSPACE/2,obj_bullet_parent, {
			team: team,	
			x_vel: ((team == "friendly")?1:-1),
			});				
		}
		if shootBottom && repeat_shot != 2 {
			instance_create_depth(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2 +random_range(-4,4) +GRIDSPACE,depth -GRIDSPACE/2,obj_bullet_parent, {
			team: team,	
			x_vel: ((team == "friendly")?1:-1),
			});				
		}
		if shootBottom || shootMid || shootTop {
			repeat_shot -= 1;
			timer = 0;
			timer_end = random_percent(1.4,4);			
		}
	}
}
