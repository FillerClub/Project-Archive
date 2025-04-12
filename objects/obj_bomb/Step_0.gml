if global.game_state != PAUSED{
	timer += delta_time*DELTA_TO_SECONDS;
}

if timer >= 1.55 {
	instance_destroy();	
}