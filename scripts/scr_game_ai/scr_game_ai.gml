function game_ai(mode = CLOSESTTOBASE, spawn_pieces = false, cheat_variable = 0){
#macro CLOSESTTOBASE 0
var enemy_piece_present = false,
friendly_piece_present = false,
arrayLengthMovesList = 0,
arrayLengthMoves = 0,
moveAvailable = false,
gS = GRIDSPACE,
gD = global.grid_dimensions,
levelWorld = global.level[0],
push = false,
moveRequest = false,
leastThreat = 0,
heroX = 0,
debugOn = global.debug,
prevSeed = random_get_seed();

with obj_generic_piece {
	var enemyP = team == global.opponent_team,
	notHeroWall = object_index != obj_hero_wall;
	 
	if enemyP && notHeroWall {
		enemy_piece_present = true;	
	} 
	if !enemyP && notHeroWall {
		friendly_piece_present = true;	
	} 
	if !enemyP && !notHeroWall {
		heroX = x;
	}
}

if !enemy_piece_present {
	exit;	
}

var countPiece = 0;
with obj_generic_piece {
	if team != global.player_team && ai_controlled {
		other.ai_pieces[countPiece] = id;
		countPiece++;
	}
}
	
var arrayLength = array_length(ai_pieces);
var canTakePiece = false;
// Grab all possible moves for pieces currently on board	
for (var inst = 0; inst < arrayLength; inst++) {
	// From each piece, grab the array of valid_moves
	with ai_pieces[inst] {
		arrayLengthMovesList = array_length(valid_moves);
		// From each valid_moves array, grab each moves list (ONLY_ATTACK, ONLY_MOVE, BOTH)
		for (var list = 0; list < arrayLengthMovesList; list++) {
			// Filter out dead arrays
			if valid_moves[list] == undefined || valid_moves[list] == 0 {
				continue;	
			}
			arrayLengthMoves = array_length(valid_moves[list]);
			// From each moves list, grab the moves available
			for (var moves = 0; moves < arrayLengthMoves; moves++) {
				var preValidX = valid_moves[list][moves][0],
				preValidY = valid_moves[list][moves][1];
				// Check if affected by team & toggle
				if is_string(preValidX) {
					preValidX = tm_dp(real(preValidX),team,toggle);
				}
				if is_string(preValidY) {
					preValidY = tm_dp(real(preValidY),team,toggle);
				}
			
				var validX = preValidX*gS +x,
				validY = preValidY*gS +y;			
				// Filter bad moves
				if position_meeting(validX,validY,obj_grid) && (preValidX != 0 || preValidY != 0) {
					// Depending on the type of moves list determine if it is able to move
					switch list {  
						case ONLY_ATTACK:
							if position_meeting(validX,validY,obj_obstacle) {
								with instance_position(validX,validY,obj_obstacle) {
									if team != other.team && !intangible && hp > 0 {    
										push = true;
									}	
								}
								if push { 
									array_push(other.ai_valid[PIECE],self);
									array_push(other.ai_valid[MOVE],[validX,validY]);
									canTakePiece = true;
									push = false;
								}
							}
						break;
							
						case ONLY_MOVE:
							if !position_meeting(validX,validY,obj_obstacle) {
								array_push(other.ai_valid[PIECE],self);
								array_push(other.ai_valid[MOVE],[validX,validY]);
							}
						break;
							
						default:
						case BOTH:
							push = true;
							if position_meeting(validX,validY,obj_obstacle) {
								with instance_position(validX,validY,obj_obstacle) {
									if team == other.team || intangible || hp <= 0 {    
										push = false;
									} else {
										canTakePiece = true;	
									}
								}
							}
							if push { 
								array_push(other.ai_valid[PIECE],self);
								array_push(other.ai_valid[MOVE],[validX,validY]);					
							}
						break;
					}
					push = false;
				}	
			}
		}	
	}
} 
var arrayLengthValid = array_length(ai_valid[PIECE]), // ai_valid[PIECE] and ai_valid[MOVE] arrays should be the same length
at = [-1],
atCount = 0,
blockingMove = false;

if arrayLengthValid <= 0 { 
	exit;
}

var 
skipMove = false,
clPiece = noone,
clX = 0,
clY = 0,
closestX = 9999;
// Decision making 
for (var cl = 0; cl < arrayLengthValid; cl++) {
	skipMove = false;
	clPiece = ai_valid[PIECE][cl];
	clX = ai_valid[MOVE][cl][0];
	clY = ai_valid[MOVE][cl][1];
	// Based on AI piece
	switch clPiece.identity {
		case "jumper":
			with clPiece {
				// Grab the attacking move immediately in front of it
				var 
				horseX = x + gS*tm_dp(int64(1),team,toggle),
				horseY = y,
				horseLookingAt = instance_position(horseX,horseY,obj_obstacle),
				shouldNotJump = true;
				
				if horseLookingAt != noone {
					if horseLookingAt.team != team {
						shouldNotJump = false;	
					}
				}
				
				// May change, but invalidate move if isn't in front of another piece
				if move_count <= 0 && shouldNotJump {
					skipMove = true;
				}
			}
		break;
		case "wall":
		case "the_goliath":
			if !position_meeting(clX,clY,obj_obstacle) {
				skipMove = true;
			}			
		break;
		default:
			if canTakePiece {
				if !position_meeting(clX,clY,obj_obstacle) {
					skipMove = true;
				}					
			}
		break;
	}
	if skipMove {
		continue;	
	}
	// Final decision based on AI mode
	switch mode {
		default:
		case CLOSESTTOBASE:			
			// If the distance between the movement's x and the friendly base's x is less than the distance regarding the previously recorded x, record the new closest position
			if clX - heroX <= closestX - heroX {
				if clX == closestX {
					atCount++;	
				}
				closestX = clX;
				at[atCount] = cl;
			}
		break;
	}	
}

// If there are preferable moves, don't move
if at[0] == -1 {
	exit;	
} else {
// Else if there are multiple preferable moves, choose from a predetermined seed
	var randRange = round((array_length(at) -1)*(ai_seed/100));
	at = at[randRange];
}

// Further down we assume we found the only move we want to make	
var
atX = ai_valid[MOVE][at][0],
atY = ai_valid[MOVE][at][1],
atInst = ai_valid[PIECE][at],
obstacleInst = noone,
obstacleHp = 10,
moveCost = 1,
timerMultiplier = 1,
commitMove = false,
isHero = false;

if position_meeting(atX,atY,obj_obstacle) {
	with instance_position(atX,atY,obj_obstacle) {
		obstacleInst = id;
		obstacleHp = max(hp,1);
	}
}

// Tutorial for taking pieces.
if levelWorld != 0 && global.tutorial_progress <= 0 {
	if position_meeting(atX,atY,obj_generic_piece) && atInst.hp > 0 {
		var tutorialTakePiece = instance_position(atX,atY,obj_generic_piece),
		TvalidMoves = tutorialTakePiece.valid_moves,
		TaLML = array_length(TvalidMoves);
		// From each valid_moves array, grab each moves list (ONLY_ATTACK, ONLY_MOVE, BOTH)
		for (var list = 0; list < TaLML; list++) {
			// Exit if the move list cannot take pieces
			if list != ONLY_ATTACK && list != BOTH {
				continue;	
			} 
			// Filter out dead arrays
			if TvalidMoves[list] == undefined || TvalidMoves[list] == 0 {
				continue;
			}
			var TaLM = array_length(TvalidMoves[list]);
			
			// From each moves list, grab the moves available
			for (var moves = 0; moves < TaLM; moves++) {
				var TpreValidX = TvalidMoves[list][moves][0],
				TpreValidY = TvalidMoves[list][moves][1];
				// Check if affected by team & toggle
				if is_string(TpreValidX) {
					TpreValidX = tm_dp(real(TpreValidX),tutorialTakePiece.team,tutorialTakePiece.toggle);
				}
				if is_string(TpreValidY) {
					TpreValidY = tm_dp(real(TpreValidY),tutorialTakePiece.team,tutorialTakePiece.toggle);
				}
			
				var TvalidX = TpreValidX*gS +tutorialTakePiece.x,
				TvalidY = TpreValidY*gS +tutorialTakePiece.y;		
				
				if position_meeting(TvalidX,TvalidY,atInst) {
					if tutorialTakePiece.execute != "move" {
						audio_play_sound(snd_pick_up,0,0);
					}	
					
					instance_destroy(obj_text_box)	
					instance_create_layer(room_width/2,TEXTYDEFAULT,"GUI",obj_text_box, {
						text: ["Your piece is in danger! However, remember you can use points to move your piece or to defeat the enemy piece."],
						bubble_color: $FF000000,
						text_color: $FFFFFFFF
					});
					with obj_generic_piece {
						execute = "nothing";	
					}
					global.tutorial_progress = 1;
					tutorialTakePiece.ignore_pause = true;
					tutorialTakePiece.skip_timer = true;
					tutorialTakePiece.execute = "move";
					tutorial_piece = tutorialTakePiece;
					global.mode = "move";
					global.game_state = PAUSED;
					exit;
				}		
			}	
		}
	}
}

// Build up timer to take piece
with atInst {
	moveCost = cost;
	timerMultiplier = ceil(obstacleHp/10)*max(moveCost,1);	
	ai_timer += delta_time*DELTA_TO_SECONDS/timerMultiplier;
	skip_timer = true;
	var Sound = snd_move;
	if obstacleInst != noone {
		Sound = snd_enemy_taking;
	}
	var sound_params = {
	sound: Sound,
	pitch: 1 +(ai_timer/time_to_take)/2,
	};		
	if !audio_is_playing(Sound){
		audio_play_sound_ext(sound_params);
	} 

	
	if ai_timer >= time_to_take {
		commitMove = true;
		ai_timer = 0;
	}							
}
// Now commit to making the move
if commitMove {
	// Change ai seed
	ai_seed = random(100);
	if obstacleInst != noone {
		// Deal Damage/Destroy Victim Piece
		with obstacleInst {
			if moveCost != 0 {
				global.opponent_turns -= ceil(hp/10)*moveCost;	
			} else {
				global.opponent_turns -= ceil(hp/10) -1;							
			}
			if object_index != obj_hero_wall {	
				hp = 0;
				instance_destroy();	
			} else {
				isHero = true;
				hp -= 10;	
			}
		}			
	}
				
	// Deal with control piece
	with atInst {
		if isHero {
			instance_destroy();		
		} else {
			x = atX;
			y = atY;
			moved = true;
			move_count++;
		}
	}

}

}