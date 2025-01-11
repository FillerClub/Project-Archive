function piece_attack(valid_attacks = [0,0], mode = BOTH, cost = 1, bypass_cooldown = false) {
var	
re = false,
gS = GRIDSPACE,
gD = global.grid_dimensions,
gOffsetX = gD[0] mod gS,
gOffsetY = gD[2] mod gS,
moveX = x,
moveY = y,
gX = obj_cursor.x,
gY = obj_cursor.y;

#macro ONLY_MOVE 0
#macro ONLY_ATTACK 1 
#macro BOTH 2
#macro FAUX 3

// Is mode on move and is the piece executing a move?
if global.mode == "move" && execute == "move" {
	// Check for second mouse press
	if input_check_pressed("action") {
		var piececlick = instance_position(gX,gY,obj_obstacle);
		
		if !bypass_cooldown {
			if (move_cooldown_timer < move_cooldown) && !position_meeting(gX,gY,self) {
				scr_error();
				audio_stop_sound(snd_critical_error);
				audio_play_sound(snd_critical_error,0,0);
				return false;	
			}	
		}
		// Check if clicked on piece
		if piececlick != -4 {
			// Cancel if clicked on illegal spot
			if piececlick.team == global.team || piececlick.intangible == true || mode == ONLY_MOVE || piececlick.hp <= 0 {
				// Exit move mode if it's team piece
/*				if piececlick.team == global.team {
					execute = "nothing";						
				}*/
				return false;					
			}
			// Check how much it would cost to take piece
			cost = move_cost_formula(piececlick.hp,cost);
		} else {
			if mode == ONLY_ATTACK {					
				return false;		
			}
		
		}
		
		// Set up variables
		var 
		gClampX = floor(gX/gS)*gS,
		gClampY = floor(gY/gS)*gS,
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
			
			var validX = preValidX*gS +x,
			validY = preValidY*gS +y,
			blockingValid = false;
			
			if (gClampX == validX)
			&& (gClampY == validY)
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
				moveX = validX;
				moveY = validY;
			}
		}
		if !moving {
			return false;	
		}
		// If it costs too much to move, exit
		switch team {
			case "friendly":
				if global.turns >= cost {
					global.turns -= cost;
					re = true;
				} else {
					audio_stop_sound(snd_critical_error);
					audio_play_sound(snd_critical_error,0,0);
					with obj_timer {
						if team == global.team {
							scr_error();
						}
					}
					with obj_turn_operator {
						if team == global.team {
							scr_error();
						}
					}
					return false;								
				}
			break;
					
			case "enemy":
				if global.enemy_turns >= cost {
					global.enemy_turns -= cost;
					re = true;
				} else {
					audio_stop_sound(snd_critical_error);
					audio_play_sound(snd_critical_error,0,0);
					with obj_timer {
						if team == global.team {
							scr_error(); 
						}
					}
					with obj_turn_operator {
						if team == global.team {
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
		move_cooldown_timer = 0;	
	}
	return re;
}