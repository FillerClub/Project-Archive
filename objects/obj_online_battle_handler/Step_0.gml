var aL = false,
cursorInstance = obj_cursor,
cursorOnGrid = cursorInstance.on_grid,
loadOpponentSlots = obj_client_manager.opponent_loadout;

if loadOpponentSlots != undefined {
	load_slots(undefined,loadOpponentSlots);
	obj_client_manager.opponent_loadout = undefined;	
}
// Handle requests
process_requests(requests,online);

piece_handling();
// Battle Timer Function
if global.game_state != PAUSED {
	timer[MAIN] += delta_time*DELTA_TO_SECONDS*global.level_speed;	
	if timer[ALERT] > 0 { timer[ALERT] -= delta_time*DELTA_TO_SECONDS*global.level_speed; }
}
if timer[MAIN] >= global.timeruplength || (global.debug && keyboard_check_pressed(vk_tab)) {
	global.max_turns += global.turn_increment;
	global.friendly_turns += global.turn_increment;
	global.enemy_turns += global.turn_increment;
	timer[ALERT] = 2.3;	
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
	timer[MAIN] = 0;
}
