var aL = false,
cursorInstance = obj_cursor,
cursorOnGrid = cursorInstance.on_grid,
loadOpponentSlots = [];

// Clean up stale predictions every second
prediction_cleanup_timer += delta_time*DELTA_TO_SECONDS;
if prediction_cleanup_timer >= 1 {
    prediction_cleanup_timer = 0;
    cleanup_stale_predictions();
}

// Handle requests
piece_handling();
process_requests(requests,online);


// Battle Timer Function
timer += delta_time*DELTA_TO_SECONDS*global.level_speed;	
if alert_timer > 0 { alert_timer -= delta_time*DELTA_TO_SECONDS*global.level_speed; }

if timer >= global.timeruplength || (global.debug && keyboard_check_pressed(vk_tab)) {
	global.max_turns += global.turn_increment;
	global.friendly_turns += global.turn_increment;
	global.enemy_turns += global.turn_increment;
	alert_timer = 2.3;	
	audio_play_sound(snd_shield_up,0,0);
	var 
	accelCountF = 0,
	accelCountE = 0;
	with obj_timer {
		draw_mute_red_green = 1;
		if accel <= global.timer_max_speed_mult {
			accel = min(accel +0.1,global.timer_max_speed_mult)
		} 
	}
	timer -= global.timeruplength;
}
