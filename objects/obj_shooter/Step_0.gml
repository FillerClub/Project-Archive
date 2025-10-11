event_inherited()

// shoot animation
if global.game_state != PAUSED {
	var delay = .3/piece_get_affected_speed(1);
	if (timer >= timer_end -delay) {
		if scan_for_enemy() {
			// Play shooting animation
			if !shooting {
				new_animation = sq_shooter_shoot;
				shooting = true;
			}
		}
	}
} 