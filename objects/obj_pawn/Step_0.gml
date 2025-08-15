event_inherited();

if global.game_state != PAUSED {
	expire_timer += delta_time*DELTA_TO_SECONDS*global.level_speed;
	if expire_timer >= 16 {
		instance_destroy();	
	}
}