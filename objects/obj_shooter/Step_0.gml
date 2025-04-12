var gS = GRIDSPACE;
event_inherited();

// shoot
if global.game_state != PAUSED {
	if (timer >= timer_end) {
		timer = 0;
		timer_end = random_percent(1.5,4);
		
		if scan_for_enemy() {
			instance_create_depth(x +sprite_width/2 +random_range(-4,4),y +sprite_height/2 +random_range(-4,4),depth -gS/2,obj_bullet_parent, {
			team: team,	
			x_vel: ((team == "friendly")?1:-1),
			});
		}
	}
}
