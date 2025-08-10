if global.game_state != PAUSED {
	timer2 += delta_time*DELTA_TO_SECONDS*global.level_speed;
	z = abs(sin(timer2*2)*120);
}


event_inherited();


/*
// shoot
if global.game_state != PAUSED {
	if (timer >= timer_end) {
		if scan_for_enemy() {
			instance_create_depth(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2 +random_range(-4,4),depth -GRIDSPACE/2,obj_bullet_parent, {
			team: team,	
			x_vel: ((team == "friendly")?1:-1),
			z: z,
			dmg: 0.01
			});
		}
		timer = 0;
		timer_end = random_percent(.01,4);
	}
}
