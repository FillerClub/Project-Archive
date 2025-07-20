

if global.game_state != PAUSED {
	timer += delta_time*DELTA_TO_SECONDS*global.level_speed;
	if (timer >= timer_end) {
		instance_destroy();
		timer = 0;
	}
}
