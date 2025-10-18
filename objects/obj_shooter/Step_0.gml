event_inherited()

// shoot animation
if global.game_state != PAUSED {
	var delay = .3/piece_get_affected_speed(1);
	if (timer >= timer_end -delay) {
		if scan_for_enemy() {
			// Play shooting animation
			if !shooting {
				new_animation = sq_shooter_shoot;
				// Determine where to exit for idle animation
				var head = layer_sequence_get_headpos(animation);
				if head > 20 && head < 43 {
					default_anim_position = 45;
				} else {
					default_anim_position = 12;
				}
				interpolation_speed = 1/10;
				starting_sequence_pos = 0;
				shooting = true;
			}
		}
	}
} 