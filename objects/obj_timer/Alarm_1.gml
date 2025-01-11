if timer_count_queue > 0 {
	timer_tick(1);
	timer_count_queue -= 1;	
	alarm[1] = .6*game_get_speed(gamespeed_fps)/(1 +timer_count_queue/1.5);
}