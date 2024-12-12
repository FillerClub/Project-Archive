function game_ai(mode = CLOSESTTOHERO, spawn_pieces = false, cheat_variable = 0){
var enemy_piece_present = false,
friendly_piece_present = false,
arrayLengthMovesList = 0,
arrayLengthMoves = 0,
moveAvailable = false,
gS = global.grid_spacing,
gD = global.grid_dimensions,
levelWorld = global.level[0],
push = false,
moveRequest = false,
leastThreat = 0,
heroX = 0,
debugOn = global.debug;

for (var lanes = 0; lanes < (gD[3] -gD[2])/gS +1; lanes += 1) {
	lane_threat[lanes] = 0;
	lane_score[lanes] = 0;
}

with obj_generic_piece {
	var enemyP = team == global.enemy_team,
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

var tickRequest = false,
xRequest = x,
yRequest = y;
	
//threat assessment
var countFPiece = 0;
with obj_obstacle {
	if team == global.team && hp > 0 {
		other.friendly_pieces[countFPiece] = id;
		countFPiece++;
	}
}
if countFPiece > 0 {
	var arrayFLength = array_length(friendly_pieces);
	for (var fPieces = 0; fPieces < arrayFLength; fPieces++) {
		var finst = friendly_pieces[fPieces],
		fY = (finst.y -gD[2])/gS;
		switch finst.identity {
			case "short":

			break;
				
			case "shooter":
				lane_threat[fY] += 1;
				lane_score[fY] += 1;
			break;
				
			case "stick":
				lane_threat[fY] += 1;
			break;
				
			case "Warden":
			case "Monarch":
				lane_score[fY] += 2;
			break;
				
			default:
				lane_score[fY] += 1;
			break;
			
		}
	}
}

if !fresh && cheat_variable != 0 {
	with obj_timer {
		if team == global.enemy_team {
			timer += delta_time*DELTA_TO_SECONDS*cheat_variable;
		}
	}
}
	
if tickRequest {
	timer[AI] += delta_time*DELTA_TO_SECONDS;	
}

if !enemy_piece_present {
	exit;	
}
var countPiece = 0;
with obj_generic_piece {
	if team != global.team && ai_controlled {
		other.ai_pieces[countPiece] = id;
		countPiece++;
	}
}
	
var arrayLength = array_length(ai_pieces);
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
var arrayLengthValid = array_length(ai_valid[PIECE]),
at = -1,
blockingMove = false;

if arrayLengthValid <= 0 { 
	exit;
}

switch mode {
	default:
	case CLOSESTTOBASE:
		var 
		closestX = 1088;
		for (var cl = 0; cl < arrayLengthValid; cl++) {
			var checkX = ai_valid[MOVE][cl][0];
			if checkX - heroX < closestX - heroX {
				closestX = checkX;
				at = cl;	
			}		
		}
	break;
}

if at == -1 {
	exit;	
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
					with obj_generic_piece {
						execute = "nothing";	
					}
					global.tutorial_progress = 1;
					tutorialTakePiece.ignore_pause = true;
					tutorialTakePiece.skip_timer = true;
					tutorialTakePiece.execute = "move";
					tutorial_piece = tutorialTakePiece;
					global.mode = "move";
					global.pause = true;
					exit;
				}		
			}	
		}
	}
}

// Build up timer to take piece
with atInst {
	moveCost = cost;
	if global.enemy_turns >= moveCost {
		timerMultiplier = ceil(obstacleHp/10)*max(moveCost,1);	
		ai_timer += delta_time*DELTA_TO_SECONDS/timerMultiplier;
		skip_timer = true;
		var sound_params = {
		sound: snd_enemy_taking,
		pitch: 1 +(ai_timer/time_to_take)/2,
		};		
		if !audio_is_playing(snd_enemy_taking) && obstacleInst != noone {
			audio_play_sound_ext(sound_params)	
		}
	}
	
	if ai_timer >= time_to_take {
		commitMove = true;
		ai_timer = 0;
	}							
}
// Now commit to making the move
if commitMove {
	if obstacleInst != noone {
		// Deal Damage/Destroy Victim Piece
		with obstacleInst {
			if moveCost != 0 {
				global.enemy_turns -= ceil(hp/10)*moveCost;	
			} else {
				global.enemy_turns -= ceil(hp/10) -1;							
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
		}
	}
}

/*	
if moveRequest && timer[AI] >= 4 {
	for (var mR = 0; mR < arrayLengthValid; mR++) {
		if ai_valid[PIECE][mR] == enemy_hero {
			var mYConvert = (ai_valid[MOVE][mR][1] -gD[2])/gS;
			if lane_threat[mYConvert] <= leastThreat {
				with ai_valid[PIECE][mR] {
					global.enemy_turns -= 1;	
					other.timer[AI] -= 4;
					x = other.ai_valid[MOVE][mR][0];
					y = other.ai_valid[MOVE][mR][1];
				}
				break;
			} 
		}
	}
}
*/
}