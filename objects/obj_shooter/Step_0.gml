event_inherited()

// shoot
if global.game_state != PAUSED {
	if (timer >= timer_end) {
		if scan_for_enemy() {
			// Play shooting animation
			if !shooting {
				new_animation = sq_shooter_shoot;
				shooting = true;
			}
			var delay = .3/piece_get_affected_speed(1);
			// Wait for animation
			if timer >= timer_end +delay {
				var zOff = z;	
				var gridOff = piece_on_grid;
				if is_string(gridOff) {
					with obj_grid {
						if tag == gridOff {
							zOff += z;
							break;
						}
					}
				} else if instance_exists(gridOff) { zOff += gridOff.z; }
				instance_create_depth(x +sprite_width/2 +tm_dp(28,team,toggle) +random_range(-4,4),y +sprite_height/2 +9 +random_range(-4,4),depth -GRIDSPACE/2,obj_bullet_parent, {
					team: team,	
					x_vel: ((team == "friendly")?1:-1),
					z: zOff,
				});
				timer = 0;
				timer_end = random_percent(1,5);
				shooting = false;
			}
		}
	}
} 