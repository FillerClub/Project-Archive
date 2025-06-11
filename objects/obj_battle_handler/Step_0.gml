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
	if cursorOnGrid != noone {
		var
		cursorX = cursorInstance.grid_pos[0]*GRIDSPACE +cursorOnGrid.bbox_left +GRIDSPACE/2,
		cursorY = cursorInstance.grid_pos[1]*GRIDSPACE +cursorOnGrid.bbox_top +GRIDSPACE/2;	
		// Upon clicking anything, reset execution for all pieces
		if position_meeting(cursorX,cursorY,obj_generic_piece) {
			with instance_position(cursorX,cursorY,obj_generic_piece) {
				if team == global.player_team && !skip_move {				
					switch global.mode {
						case "delete":
							if !global.debug {
								if object_get_parent(object_index) != obj_generic_hero_OLD && team == global.player_team {
									instance_destroy();
								}						
							} else if !intangible {
								hp -= 10;	
							}					
						break;
						case "move":
							if execute != "move" { 
								with obj_generic_piece { if team == global.player_team { execute = "nothing"; } }	
								skip_move = true;
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
							clickedOn = false;
				
							for (var set = 0; set < setsOfMoves; ++set)	{	
								var arLeng = array_length(valid_moves[set]);
								// For each move available (i)
								for (var i = 0; i < arLeng; ++i)	{
									var
									onGrid = noone,
									pieceX = x,
									pieceY = y,
									precheckX = valid_moves[set][i][0],
									precheckY = valid_moves[set][i][1];
									// Check if affected by team & toggle
									if is_string(precheckX) {
										precheckX = tm_dp(real(precheckX),team,toggle);
									}
									if is_string(precheckY) {
										precheckY = tm_dp(real(precheckY),team,toggle);
									}
									//draw_text(x,y+80 +16*moves,string(precheckX) +" : "+string(precheckY));
									// Center coordinates if is drawing from piece
									pieceX = x +(precheckX +.5)*GRIDSPACE;
									pieceY = y +(precheckY +.5)*GRIDSPACE;
									// Snap to grid if it is on one
									if position_meeting(pieceX,pieceY,obj_grid) {
										onGrid = instance_position(pieceX,pieceY,obj_grid);
										pieceX = floor((pieceX -onGrid.bbox_left)/GRIDSPACE)*GRIDSPACE +onGrid.bbox_left +GRIDSPACE/2;
										pieceY = floor((pieceY -onGrid.bbox_top)/GRIDSPACE)*GRIDSPACE +onGrid.bbox_top +GRIDSPACE/2;	
										// Verify position is actually on grid
										if !position_meeting(pieceX,pieceY,onGrid) {
											audio_stop_sound(snd_bullet_hit);	
											audio_play_sound(snd_bullet_hit,0,0);
											continue;	
										}
									}
									if (cursorX == pieceX) && (cursorY == pieceY) && (precheckX != 0 || precheckY != 0) {
										clickedOn = true;
									} 	
								}
							}
							if !clickedOn { 
								execute = "nothing"; 
								select_sound(snd_put_down);
							} else {
								audio_stop_sound(snd_bullet_hit);	
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
	} else with obj_generic_piece {
		if team == global.player_team {
			if execute == "move" { select_sound(snd_put_down); }
			execute = "nothing";
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
			global.max_turns++;
			global.player_turns++;
			global.opponent_turns++;
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
	#macro MOVE 1
	#macro PIECE 2
		ai_pieces = [];
		friendly_pieces = [];
		lane_threat = [];
		lane_score = [];
		ai_valid[PIECE] = [];
		ai_valid[MOVE] = [];
		game_ai(ai_mode);
	break;
}