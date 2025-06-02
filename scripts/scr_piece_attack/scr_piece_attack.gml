function piece_attack(valid_attacks = [0,0], mode = BOTH, cost = 1, bypass_cooldown = false) {
#macro ONLY_MOVE 0
#macro ONLY_ATTACK 1 
#macro BOTH 2
#macro FAUX 3
var 
re = false,
cursorInstance = obj_cursor,
cursorX = cursorInstance.x,
cursorY = cursorInstance.y,
precheckX = x,
precheckY = y,
moveToX = x,
moveToY = y,
cursorOnGrid = obj_cursor.on_grid,
cursorGridPosition = obj_cursor.grid_pos,
piececlick = noone,
ar_leng = array_length(valid_attacks),
moving = false;

if global.mode == "move" && execute == "move" {
	if input_check_pressed("action") && cursorOnGrid != noone {
		if !bypass_cooldown && move_cooldown_timer > 0 {
			scr_error();
			audio_stop_sound(snd_critical_error);
			audio_play_sound(snd_critical_error,0,0);
			return false;	
		}
		// Grab cursor position on board
		cursorX = cursorGridPosition[0]*GRIDSPACE +cursorOnGrid.bbox_left +GRIDSPACE/2;
		cursorY = cursorGridPosition[1]*GRIDSPACE +cursorOnGrid.bbox_top +GRIDSPACE/2;
		// Check if clicked on piece
		if position_meeting(cursorX,cursorY,obj_obstacle) {
			piececlick = instance_position(cursorX,cursorY,obj_obstacle);
			// Cancel if clicked on illegal spot
			if piececlick.team != global.opponent_team || piececlick.intangible == true || mode == ONLY_MOVE || piececlick.hp <= 0 {
				// Exit move mode if it's team piece
				if piececlick.team == global.player_team {
					execute = "nothing";						
				}
				return false;					
			}
		// Else if move set is only attacking, exit
		} else if mode == ONLY_ATTACK {
			return false;	
		}
		for (var moves = 0; moves < ar_leng; ++moves) {
			precheckX = valid_attacks[moves][0];
			precheckY = valid_attacks[moves][1];
			// Check if affected by team & toggle
			if is_string(precheckX) {
				precheckX = tm_dp(real(precheckX),team,toggle);
			}
			if is_string(precheckY) {
				precheckY = tm_dp(real(precheckY),team,toggle);
			}
			// Center coordinates if is drawing from piece
			moveToX = x +(precheckX +.5)*GRIDSPACE;
			moveToY = y +(precheckY +.5)*GRIDSPACE;		
			// If the move does not fall onto a grid, or is on self, ignore it.
			if !position_meeting(moveToX,moveToY,obj_grid) || (precheckX == 0 && precheckY == 0) {
				continue;	
			} 
			// Get the move's position on the grid so we can check for it easier
			var
			moveToGrid = instance_position(moveToX,moveToY,obj_grid),
			gClampX = floor((moveToX -moveToGrid.bbox_left)/GRIDSPACE)*GRIDSPACE +moveToGrid.bbox_left +GRIDSPACE/2,
			gClampY = floor((moveToY -moveToGrid.bbox_top)/GRIDSPACE)*GRIDSPACE +moveToGrid.bbox_top +GRIDSPACE/2;
			// If cursor is hovering over the move position, determine that's the move we want to make
			if (gClampX == cursorX) && (gClampY == cursorY) {
				moving = true;
				break;
			} 
			
		}
		// At this point, we go back to using "return false;" instead of "continue;"
		if !moving {
			return false;	
		}
		// Deny moving into blockades
		if position_meeting(cursorX,cursorY,obj_territory_blockade) {
			var sound_params = {
					sound: snd_oip,
					pitch: random_range(0.85,1.15),
			};
			repeat(45) {
				part_particles_burst(global.part_sys,cursorX,cursorY,part_slap);		
			}
			audio_play_sound_ext(sound_params);	
			return false;	
		}	
		// If it costs too much to move, exit
		var affordable = false;
		switch team {
			case "friendly":
				if global.player_turns >= cost {
					global.player_turns -= cost;
					affordable = true;
				} 
			break;
					
			case "enemy":
				if global.opponent_turns >= cost {
					global.opponent_turns -= cost;
					affordable = true;
				} 
			break;
		}
		if !affordable {
			audio_stop_sound(snd_critical_error);
			audio_play_sound(snd_critical_error,0,0);
			with obj_timer {
				if team == global.player_team {
					scr_error();
				}
			}
			with obj_turn_operator {
				if team == global.player_team {
					scr_error();
				}
			}
			return false;
		}
		// Handle special cases for moving onto different pieces
		if piececlick != noone {
			switch piececlick.object_index {
				case obj_hero_wall:
					piececlick.hp -= attack_power;
					instance_destroy();			
					// Never destroy a hero wall
				break;
				
				default:
					piececlick.hp -= attack_power;
					if piececlick.hp <= 0 {
						// Destroy target piece if it's hp is 0
						instance_destroy(piececlick);
					} else {
						// Destroy the attacking piece if it's too weak, while still knocking down hp
						instance_destroy();	
					}
				break;
			}			
		}
		// At this point, we are confident in committing to the move.
		re = true;
		if re && !bypass_cooldown {
			move_cooldown_timer = move_cooldown;	
		}
		// Move, while changing the grid position
		x = gClampX -GRIDSPACE/2;
		y = gClampY -GRIDSPACE/2;
		grid_pos = [cursorGridPosition[0],cursorGridPosition[1]];
		piece_on_grid = moveToGrid;
		return re;	
	}
}
/*
var	
re = false,
moveX = x,
moveY = y,
cursorInstance = obj_cursor,
gX = cursorInstance.x,
gY = cursorInstance.y,
onGrid = cursorInstance.on_grid;



// Is mode on move and is the piece executing a move?
if global.mode == "move" && execute == "move" {
	// Check for second mouse press
	if input_check_pressed("action") {
		var piececlick = instance_position(gX,gY,obj_obstacle);
		
		if !bypass_cooldown {
			if (move_cooldown_timer > 0) && !position_meeting(gX,gY,self) {
				scr_error();
				audio_stop_sound(snd_critical_error);
				audio_play_sound(snd_critical_error,0,0);
				return false;	
			}	
		}
		// Check if clicked on piece
		if piececlick != -4 {
			// Cancel if clicked on illegal spot
			if piececlick.team == global.player_team || piececlick.intangible == true || mode == ONLY_MOVE || piececlick.hp <= 0 {
				// Exit move mode if it's team piece
				if piececlick.team == global.player_team {
					execute = "nothing";						
				}
				return false;					
			}
			// Check how much it would cost to take piece
			//cost = move_cost_formula(piececlick.hp,cost);
		} else {
			if mode == ONLY_ATTACK {					
				return false;		
			}
		
		}
		
		// Set up variables
		var 
		clientPresent = instance_exists(obj_client),	
		ar_leng = array_length(valid_attacks),
		moving = false;

		
		// Check where to move
		for (var i = 0; i < ar_leng; ++i) {
			var preValidX = valid_attacks[i][0],
			preValidY = valid_attacks[i][1];
			// Check if affected by team & toggle
			if is_string(preValidX) {
				preValidX = tm_dp(int64(preValidX),team,toggle);
			}
			if is_string(preValidY) {
				preValidY = tm_dp(int64(preValidY),team,toggle);
			}
			
			var validX = preValidX*GRIDSPACE +x +GRIDSPACE/2,
			validY = preValidY*GRIDSPACE +y +GRIDSPACE/2,
			blockingValid = false;
			
			//Snap to grid
			if position_meeting(validX,validY,obj_grid) {
				var 
				movetoGrid = instance_position(validX,validY,obj_grid),
				gClampX = floor((validX -movetoGrid.bbox_left)/GRIDSPACE)*GRIDSPACE +bbox_left,
				gClampY = floor((validY -movetoGrid.bbox_top)/GRIDSPACE)*GRIDSPACE +bbox_top,
				cClampX = floor((gX -movetoGrid.bbox_left)/GRIDSPACE)*GRIDSPACE +bbox_left,
				cClampY = floor((gY -movetoGrid.bbox_top)/GRIDSPACE)*GRIDSPACE +bbox_top;
			} else {
				return false;
			}		
			if (gClampX == cClampX)
			&& (gClampY == cClampY)
			&& (position_meeting(gClampX,gClampY,obj_grid)) {
				
				// Slap
				if position_meeting(gClampX,gClampY,obj_territory_blockade) {
					with instance_position(gClampX,gClampY,obj_territory_blockade) {
						if team != other.team {
							blockingValid = true;	
						}
					}
				}
				if blockingValid {
					var sound_params = {
							sound: snd_oip,
							pitch: random_range(0.85,1.15),
					};
					repeat(45) {
						part_particles_burst(global.part_sys,gX,gY,part_slap);		
					}
					audio_play_sound_ext(sound_params);	
					return false;	
				}
				
				// Set move
				moving = true;
				moveX = gClampX;
				moveY = gClampY;
			}
		}
		if !moving {
			return false;
		}
		// If it costs too much to move, exit
		switch team {
			case "friendly":
				if global.player_turns >= cost {
					global.player_turns -= cost;
					re = true;
				} else {
					audio_stop_sound(snd_critical_error);
					audio_play_sound(snd_critical_error,0,0);
					with obj_timer {
						if team == global.player_team {
							scr_error();
						}
					}
					with obj_turn_operator {
						if team == global.player_team {
							scr_error();
						}
					}
					return false;								
				}
			break;
					
			case "enemy":
				if global.opponent_turns >= cost {
					global.opponent_turns -= cost;
					re = true;
				} else {
					audio_stop_sound(snd_critical_error);
					audio_play_sound(snd_critical_error,0,0);
					with obj_timer {
						if team == global.player_team {
							scr_error(); 
						}
					}
					with obj_turn_operator {
						if team == global.player_team {
							scr_error(); 
						}
					}
					return false;					
				}
			break;
		}
		
		// What to do for each piece
		if piececlick != -4 {
				switch piececlick.object_index {
					case obj_hero_wall:
						piececlick.hp -= 10;
						instance_destroy();				
					break;
				
					default:
						with instance_position(moveX,moveY,obj_obstacle) {
							instance_destroy();	
						}
					break;
				}			
			}
		}
		//move
		x = moveX;
		y = moveY;
	} 
	if re && !bypass_cooldown {
		move_cooldown_timer = move_cooldown;	
	}
	return re;
*/	
}