if input_check_pressed("pause") {
	pause_game(on_pause_menu);	
}
if tutorial_piece != noone {
	handle_tutorials(global.tutorial_progress);
}

if global.pause {
	exit;	
}
	
var aL = false,
gS = GRIDSPACE,
mosX = floor(obj_cursor.x/gS)*gS,
mosY = floor(obj_cursor.y/gS)*gS;

// Piece Handling
if input_check_pressed("action") && !instance_exists(obj_dummy) {
	// Upon clicking anything, reset execution for all pieces
	if position_meeting(mosX,mosY,obj_generic_piece) {
		with instance_position(mosX,mosY,obj_generic_piece) {
			if team == global.team && !skip_move {				
				switch global.mode {
					case "delete":
						if !global.debug {
							if object_get_parent(object_index) != obj_generic_hero_OLD && team == global.team {
								instance_destroy();
							}						
						} else if !intangible {
							hp -= 5;	
						}					
					break;
					case "move":
						if execute != "move" { 
							with obj_generic_piece { execute = "nothing"; }	
							execute = "move"
							select_sound(snd_pick_up);
						} else { 
							execute = "nothing";
							select_sound(snd_put_down);
						}
					break;
				}
			}
		}
	} else {
		var movingCount = 0;
		with obj_generic_piece {
			if execute == "move" {
				movingCount++ 
				// Fail-safe if two or more pieces are moving
				if movingCount > 1 {
					break;	
				}
				// If it is a special piece, execute special code for moving 
				switch object_index {
					default:
						var 
						setsOfMoves = array_length(valid_moves),
						clickedOn = false,
						gcX = floor(x/gS)*gS,
						gcY = floor(y/gS)*gS;
				
						for (var set = 0; set < setsOfMoves; ++set)	{	
							var arLeng = array_length(valid_moves[set]);
							// For each move available (i)
							for (var i = 0; i < arLeng; ++i)	{
								var preValidX = valid_moves[set][i][0],
								preValidY = valid_moves[set][i][1];
								// Check if affected by team & toggle
								if is_string(preValidX) {
									preValidX = tm_dp(real(preValidX),team,toggle);
								}
								if is_string(preValidY) {
									preValidY = tm_dp(real(preValidY),team,toggle);
								}
								var xM = preValidX*gS +gcX;
								var yM = preValidY*gS +gcY;		
								if (mosX == xM) && (mosY == yM) && (valid_moves[set][i][0] != 0 || valid_moves[set][i][1] != 0) {
									clickedOn = true;
								} 	
							}
						}
						if !clickedOn { 
							execute = "nothing"; 
							select_sound(snd_put_down);
						}
					break;
					case obj_bomber:
						// Do nothing							
					break;
				}
			} else {
				execute = "nothing";
			}
		}
	}
}
#macro TIMERUPLENGTH 50
// Battle Timer Function
switch room {
	case rm_setup:
	break;
	
	case rm_journal:
		global.turns = 9999;
	break;
	
	default:
		if !global.pause {
			timer[MAIN] += delta_time*DELTA_TO_SECONDS;	
			if timer[ALERT] > 0 { timer[ALERT] -= delta_time*DELTA_TO_SECONDS; }
		}
		if timer[MAIN] >= TIMERUPLENGTH || (global.debug && keyboard_check_pressed(vk_tab)) {
			global.max_turns += 1;
			global.turns += 1;
			global.enemy_turns += 1;
			timer[ALERT] = 2.3;	
			audio_play_sound(snd_shield_up,0,0);
			var 
			accelCountF = 0,
			accelCountE = 0;
			with obj_accelerator {
				sprite_accel = 1;
				if team == "friendly" {
					accelCountF++;
				}
				if team == "enemy" {
					accelCountE++;
				}
			}
			with obj_timer {
				draw_mute_red_green = 1;
				if accel <= global.timer_max_speed_mult {
					accel = min(accel +0.3,global.timer_max_speed_mult)
				} 
				if team == "friendly" {
					timer_count_queue = accelCountF;
					alarm[1] = .6*game_get_speed(gamespeed_fps)/(1 +accelCountF/1.5);
				}
				if team == "enemy" {
					timer_count_queue = accelCountE;
					alarm[1] = .6*game_get_speed(gamespeed_fps)/(1 +accelCountE/1.5);
				}	
			}
			// Refresh powers up to three times
			timer_phase++;
			if timer_phase < 3 {
				if timer_phase >= 0 {
					with obj_power_slot {
						if identity == "a" {
							usable = true;
						}
					}		
				}
				if timer_phase >= 1 {
					with obj_power_slot {
						if identity == "b" {
							usable = true;
						}
					}		
				}
				if timer_phase >= 2 {
					with obj_power_slot {
						if identity == "c" {
							usable = true;
						}
					}		
				}
			}
			timer[MAIN] = 0;
		}
	break;
}
// Battle AI
switch room {
	case rm_world_one:
	#macro MOVE 1
	#macro PIECE 2
		ai_pieces = [];
		friendly_pieces = [];
		lane_threat = [];
		lane_score = [];
		ai_valid[PIECE] = [];
		ai_valid[MOVE] = [];
		var spawnPieces = false;
		game_ai(ai_mode,spawnPieces,.2);
	break;
}

//Debug functions
if global.debug {
	if input_check_pressed("special") {
		with instance_position(obj_cursor.x,obj_cursor.y,obj_piece_slot) {
			switch object_index {
				case obj_piece_slot:
					cooldown = cooldown_length;
				break;
				case obj_power_slot:
					usable = true;
				break;
			}
		}
		with instance_position(obj_cursor.x,obj_cursor.y,obj_generic_piece) {
			switch identity {
				default:
					move_cooldown = move_cooldown_timer; 
				break;
			}
		}
	}
}