if team != "neutral" && global.game_state != PAUSED {
	if shift_timer >= 4 {
		timer += 2*pi*delta_time*DELTA_TO_SECONDS/5;
		var flip = (team == "friendly")?0:1;
		var ref = obj_TEST_grid_center;
		x = ref.x +sin(timer -pi/2 +flip*pi)*(bbox_right-bbox_left);
		y = ref.y +cos(timer -pi/2 +flip*pi)*(bbox_bottom-bbox_top);
		if timer >= timer_step {
			timer = floor(timer/(pi/2))*(pi/2);
			timer_step += pi/2;
			if timer_step > 2*pi {
				timer_step -= 2*pi;
				timer = 0;
			}
			shift_timer = 0;
		}
	} else {
		shift_timer += delta_time*DELTA_TO_SECONDS;
	}
}