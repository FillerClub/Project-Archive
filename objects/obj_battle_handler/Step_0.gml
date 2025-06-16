var aL = false,
cursorInstance = obj_cursor,
cursorOnGrid = cursorInstance.on_grid;

if tutorial_piece != noone {
	handle_tutorials(global.tutorial_progress);
}

if global.game_state == PAUSED {
	exit;	
}

// Piece Handling
if input_check_pressed("action") && !instance_exists(obj_dummy) { 
	var clickedOn = instance_position(obj_cursor.x,obj_cursor.y,obj_generic_piece);	
	if clickedOn != noone {
		switch global.mode {
			case "delete":
				instance_destroy(clickedOn);
			break;
			default:
				if clickedOn.team == global.player_team && clickedOn != tutorial_piece {
					with obj_generic_piece {
						if team == global.player_team && !position_meeting(obj_cursor.x,obj_cursor.y,self) {
							execute = "nothing";
						}
					}
					var ignoreClick = false;
					switch clickedOn.identity {
						case "accelerator":
							if clickedOn.resource_timer >= clickedOn.time_to_produce {
								ignoreClick = true;
							}
						default:
							if ignoreClick {
								clickedOn.skip_click = true;
								break;	
							}
							if clickedOn.execute != "move" {
								clickedOn.execute = "move";	
								clickedOn.skip_click = true;
								audio_stop_sound(snd_put_down);
								audio_play_sound(snd_pick_up,0,0);
							} else {
								clickedOn.execute = "nothing";
								audio_stop_sound(snd_pick_up);
								audio_play_sound(snd_put_down,0,0);
							}			
						break;
					}
				}
			break;
		}
	}
}
// Battle Timer Function
switch room {
	case rm_main_menu:
	break;
	
	case rm_journal:
	case rm_loadout_zone:
		global.player_turns = 9999;
	break;
	
	default:
		if global.game_state != PAUSED {
			timer[MAIN] += delta_time*DELTA_TO_SECONDS;	
			if timer[ALERT] > 0 { timer[ALERT] -= delta_time*DELTA_TO_SECONDS; }
		}
		if timer[MAIN] >= global.timeruplength || (global.debug && keyboard_check_pressed(vk_tab)) {
			global.max_turns += global.turn_increment;
			global.player_turns += global.turn_increment;
			global.opponent_turns += global.turn_increment;
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
	break;
}
// Battle AI
switch room {
	case rm_world_one:
		game_ai(ai_mode);
	break;
}