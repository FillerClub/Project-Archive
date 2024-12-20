event_inherited();

// shoot
if !global.pause {
	if (timer >= timer_end) {
		timer = 0;
		timer_end = 1.6;
		
		if scan_for_enemy() {
			instance_create_layer(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2 +random_range(-4,4),"Instances",obj_bullet_parent, {
			team: team,	
			x_vel: ((team == "friendly")?1:-1),
			});
		}
	}
}
