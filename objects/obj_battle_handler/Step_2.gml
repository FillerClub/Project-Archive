var aL = false,
cursorInstance = obj_cursor,
cursorOnGrid = cursorInstance.on_grid;

if tutorial_piece != noone {
	// Handle requests
	piece_handling();
	handle_tutorials(global.tutorial_progress);
	process_requests(requests,online);
}

if global.game_state == PAUSED {
	exit;	
}
// Handle requests
piece_handling();
process_requests(requests,online);

if change_in_speed {
	global.level_speed = speed_factor;
	change_in_speed = false;
}

// Battle Timer Function
switch room {
	case rm_main_menu:
	break;
	
	case rm_journal:
	case rm_loadout_zone:
		global.friendly_turns = 9999;
	break;
	
	default:
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
					accel = min(accel +0.025,global.timer_max_speed_mult)
				} 
			}
			
			// Bonus functionality
			/*
			with obj_constant_reload {
				if ammo < 6 {
					audio_play_from_array([snd_lonestar_reload],.2);
					ammo++;
				}
			}
			*/
			timer[MAIN] = 0;
		}
	break;
}
// Battle AI
switch room {
	case rm_world_one:
		game_ai(ai_mode);
	break;
}