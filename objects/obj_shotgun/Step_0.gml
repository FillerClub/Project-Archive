event_inherited();

// shoot
if !global.pause {
	if (timer >= timer_end) {
		repeat_shot -= 1;
		timer = 0;
		timer_end = 2.6*random_range(0.98,1.02);
		
		if repeat_shot <= 0 {
			repeat_shot = 2
		} 
		
		if repeat_shot > 1 {
			timer = timer_end*.8;	
		}
		
		if scan_for_enemy(4) {
			repeat 12 {
				instance_create_layer(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2 +random_range(-4,4),"Instances",obj_pellet, {
				team: team,	
				});
			}
		}	
	}
}

