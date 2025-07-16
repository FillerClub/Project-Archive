function game_ai(mode = CLOSESTTOBASE) {
#macro CLOSESTTOBASE 0
#macro FURTHESTFROMBASE 1
ai_pieces = [];
friendly_pieces = [];
ai_valid[AI.PIECE] = [];
ai_valid[AI.GRID] = [];
ai_valid[AI.COORD] = [];
ai_final = [];
var 
countPiece = 0;
with obj_generic_piece {
	if team != global.player_team && ai_controlled {
		other.ai_pieces[countPiece] = self;
		countPiece++;
	}
}	
// If we can't find any AI pieces, leave
if countPiece == 0 || global.game_state == PAUSED {
	exit;	
}
var 
debugOn = global.debug,
arrayLength = array_length(ai_pieces),
pieceInst = noone,
canTakePiece = false,
arrayLengthMovesList = [],
arrayLengthMoves = [],
pushMoveToList = false,
moveOnGrid = noone,
moveOnPiece = noone,
movePos = [];

// Grab all ai pieces currently on board	
for (var inst = 0; inst < arrayLength; inst++) {
	// From each piece, grab the array of valid_moves
	pieceInst = ai_pieces[inst];
	arrayLengthMovesList = array_length(pieceInst.valid_moves);
	for (var list = 0; list < arrayLengthMovesList; list++) {
		// Filter out dead arrays
		if pieceInst.valid_moves[list] == undefined || pieceInst.valid_moves[list] == 0 {
			continue;	
		}
		arrayLengthMoves = array_length(pieceInst.valid_moves[list]);
		// From each moves list, grab the moves available
		for (var moves = 0; moves < arrayLengthMoves; moves++) {
			var 
			preValidX = pieceInst.valid_moves[list][moves][0],
			preValidY = pieceInst.valid_moves[list][moves][1];
			pushMoveToList = false;
			// Check if affected by team & toggle
			if is_string(preValidX) {
				preValidX = tm_dp(real(preValidX),pieceInst.team,pieceInst.toggle);
			}
			if is_string(preValidY) {
				preValidY = tm_dp(real(preValidY),pieceInst.team,pieceInst.toggle);
			}
			
			var validX = preValidX*GRIDSPACE +pieceInst.x +GRIDSPACE/2,
			validY = preValidY*GRIDSPACE +pieceInst.y +GRIDSPACE/2;			
			// Filter bad moves
			if !position_meeting(validX,validY,obj_grid) || (preValidX != 0 && preValidY != 0) {
				continue;	
			}
			// Grab grid 
			moveOnGrid = instance_position(validX,validY,obj_grid);
			// Convert position to fit on grid
			movePos = [floor((validX -moveOnGrid.bbox_left)/GRIDSPACE),floor((validY -moveOnGrid.bbox_top)/GRIDSPACE)];
			validX = movePos[0]*GRIDSPACE +moveOnGrid.bbox_left +GRIDSPACE/2;
			validY = movePos[1]*GRIDSPACE +moveOnGrid.bbox_top +GRIDSPACE/2; 
			// Check if moving to a piece
			
			// Depending on the type of moves list determine if it is able to move
			switch list {  
				case ONLY_ATTACK:
					if position_meeting(validX,validY,obj_obstacle) {
						with instance_position(validX,validY,obj_obstacle) {
							if pieceInst.team != team && !intangible && hp > 0 {    
								pushMoveToList = true;
							}	
						}
						if pushMoveToList { 
							array_push(ai_valid[AI.PIECE],pieceInst);
							array_push(ai_valid[AI.GRID],moveOnGrid);
							array_push(ai_valid[AI.COORD],movePos);
							canTakePiece = true;
							pushMoveToList = false;
						}
					}
				break;
							
				case ONLY_MOVE:
					if !position_meeting(validX,validY,obj_obstacle) {
						array_push(ai_valid[AI.PIECE],pieceInst);
						array_push(ai_valid[AI.GRID],moveOnGrid);
						array_push(ai_valid[AI.COORD],movePos);
					}
				break;
							
				default:
				case BOTH:
					pushMoveToList = true;
					if position_meeting(validX,validY,obj_obstacle) {
						with instance_position(validX,validY,obj_obstacle) {
							if pieceInst.team == team || intangible || hp <= 0 {    
								pushMoveToList = false;
							} else {
								canTakePiece = true;	
							}
						}
					}
					if pushMoveToList { 
						array_push(ai_valid[AI.PIECE],pieceInst);
						array_push(ai_valid[AI.GRID],moveOnGrid);
						array_push(ai_valid[AI.COORD],movePos);			
					}
				break;
			}
			pushMoveToList = false;				
		}
	}
}

var arrayLengthValid = array_length(ai_valid[AI.PIECE]); // ai_valid[AI.PIECE], ai_valid[AI.GRID], and ai_valid[AI.COORD] arrays should be the same length

if arrayLengthValid <= 0 { 
	exit;
}

var 
trackMoves = [[noone,noone,[0,0]]];


for (var sortMoves = 0; sortMoves < arrayLengthValid; sortMoves++) {
	var 
	sortGrid = ai_valid[AI.GRID][sortMoves],
	sortGridX = sortGrid.x,
	sortGridY = sortGrid.y,
	sortCoord = ai_valid[AI.COORD][sortMoves],
	sortX = sortCoord[0]*GRIDSPACE +sortGridX +GRIDSPACE/2,
	sortY = sortCoord[1]*GRIDSPACE +sortGridY +GRIDSPACE/2,
	sortPiece = ai_valid[AI.PIECE][sortMoves],
	sortPieceColliding = noone,
	skipMove = false;
	
	if position_meeting(sortX,sortY,obj_obstacle) {
		sortPieceColliding = instance_position(sortX,sortY,obj_obstacle);
	}
	// Based on AI piece
	switch sortPiece.identity {
		case "jumper":
			with sortPiece {
				// Grab the attacking move immediately in front of it
				var 
				horseX = x +GRIDSPACE*tm_dp(int64(1),team,toggle) +GRIDSPACE/2,
				horseY = y +GRIDSPACE/2,
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
		case "the_goliath":
		case "crawler":
		case "drooper":
		case "tank_crawler":
		case "super_tank_crawler":
			if !position_meeting(sortX,sortY,obj_obstacle) {
				skipMove = true;
			}			
		break;
		default:
			if !position_meeting(sortX,sortY,obj_obstacle) || sortPiece.attack_power < sortPieceColliding.hp {
				skipMove = true;
			}					
		break;
	}
	if skipMove {
		continue;	
	}
	var skipPush = false;
	// Scan to see if the piece already has a valid move
	for (var track = 0; track < array_length(trackMoves); track++) {
		var comparePiece = trackMoves[track][AI.PIECE];
		if sortPiece == comparePiece {
			// Sort moves by same piece based on mode
			switch mode {
				default:
				case CLOSESTTOBASE:
					// Grab distance of wall closest to piece
					var 
					distanceA = infinity,
					distanceB = infinity;
					with obj_hero_wall {
						if team != global.player_team {
							continue;	
						}
						var 
						distSort = distance_to_point(sortX,sortY),
						distComp = distance_to_point(trackMoves[track][AI.COORD][0]*GRIDSPACE +trackMoves[track][AI.GRID].bbox_left +GRIDSPACE/2,trackMoves[track][AI.COORD][1]*GRIDSPACE +trackMoves[track][AI.GRID].bbox_top +GRIDSPACE/2);
						if distSort < distanceA {
							distanceA = distSort;
						}
						
						if distComp < distanceB {
							distanceB = distComp;
						}
					}
					if distanceA < distanceB || (irandom_range(0,1) && distanceA == distanceB) {
						trackMoves[track] = [sortPiece,sortGrid,sortCoord];
					} 
				break;
				case FURTHESTFROMBASE:
					// Grab distance of wall closest to piece
					var 
					distanceA = -1,
					distanceB = -1;
					with obj_hero_wall {
						if team != global.player_team {
							continue;	
						}
						var 
						distSort = distance_to_point(sortX,sortY),
						distComp = distance_to_point(trackMoves[track][AI.COORD][0]*GRIDSPACE +trackMoves[track][AI.GRID].bbox_left +GRIDSPACE/2,trackMoves[track][AI.COORD][1]*GRIDSPACE +trackMoves[track][AI.GRID].bbox_top +GRIDSPACE/2);
						if distSort > distanceA {
							distanceA = distSort;
						}
						
						if distComp > distanceB {
							distanceB = distComp;
						}
					}
					if distanceA > distanceB || (irandom_range(0,1) && distanceA == distanceB) {
						trackMoves[track] = [sortPiece,sortGrid,sortCoord];
					} 
				break;
			}
			// We either replace the compare set or skip pushing it
			skipPush = true;
		}
	}
	if !skipPush {
		array_push(trackMoves,[sortPiece,sortGrid,sortCoord]);
	}
}
var trackArrLeng = array_length(trackMoves);
if trackArrLeng <= 1 {
	exit;
}
for (var finalScan = 1; finalScan < trackArrLeng; finalScan++) {
	// Tutorial for taking pieces. Take first entry on list
	var 
	levelWorld = global.level[0],
	PieceEnemy = trackMoves[finalScan][AI.PIECE],
	EnemyOnGrid = trackMoves[finalScan][AI.GRID],
	EnemyPos = trackMoves[finalScan][AI.COORD],
	targetX = EnemyPos[0]*GRIDSPACE +EnemyOnGrid.x +GRIDSPACE/2,
	targetY = EnemyPos[1]*GRIDSPACE +EnemyOnGrid.y +GRIDSPACE/2,
	PieceVictim = instance_position(targetX,targetY,obj_obstacle);	
	if levelWorld != 0 && global.tutorial_progress <= 0 && position_meeting(targetX,targetY,obj_obstacle) {
		if PieceVictim.hp > 0 {
			var TvalidMoves = PieceVictim.valid_moves,
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
					var TprecheckX = TvalidMoves[list][moves][0],
					TprecheckY = TvalidMoves[list][moves][1];
					// Check if affected by team & toggle
					if is_string(TprecheckX) {
						TprecheckX = tm_dp(real(TprecheckX),PieceVictim.team,PieceVictim.toggle);
					}
					if is_string(TprecheckY) {
						TprecheckY = tm_dp(real(TprecheckY),PieceVictim.team,PieceVictim.toggle);
					}
					// Center coordinates
					var TvalidX = PieceVictim.x +(TprecheckX +.5)*GRIDSPACE,
					TvalidY = PieceVictim.y +(TprecheckY +.5)*GRIDSPACE;		
					
					// If the move does not fall onto a grid, or is on self, ignore it.
					if !position_meeting(TvalidX,TvalidY,obj_grid) || (TprecheckX == 0 && TprecheckY == 0) {
						audio_stop_sound(snd_warning);
						audio_play_sound(snd_warning,0,0);
						continue;	
					} 
			
					if position_meeting(TvalidX,TvalidY,PieceEnemy) {
						if PieceVictim.attack_power < PieceEnemy.hp {
							PieceEnemy.hp = PieceVictim.attack_power; 	
							PieceEnemy.hp_init = PieceVictim.attack_power; 
							audio_play_sound(snd_bullet_hit,0,0);
						}
						if PieceVictim.execute != "move" {
							audio_play_sound(snd_pick_up,0,0);
						}	
					
						instance_destroy(obj_text_box)	
						instance_create_layer(room_width/2,TEXTYDEFAULT,"GUI",obj_text_box, {
							text: ["Your piece is in danger! Looks like your piece has enough power to take that piece before it takes yours."],
							bubble_color: $FF000000,
							text_color: $FFFFFFFF
						});
						with obj_generic_piece {
							execute = "nothing";	
						}
						global.tutorial_progress = 1;
						PieceVictim.ignore_pause = true;
						PieceVictim.skip_timer = true;
						PieceVictim.execute = "move";
						tutorial_piece = PieceVictim;
						global.mode = "move";
						global.game_state = PAUSED;
						exit;
					}		
				}	
			}
		}
	}
	// If not doing tutorial, make AI move the pieces
	var commitMove = false,
	destroyEnemy = false,
	Cost = 0;
	
	with PieceEnemy {
		// Build up timer to take piece, based on cost
		Cost = cost;
		var timeDivisor = 1;
		if PieceVictim.hp < attack_power {
			timeDivisor = lerp(1,1.5,(attack_power -PieceVictim.hp)/attack_power)
		}
		var 
		timerMultiplier = 1 +Cost/1.5,
		sPD = effects_array[EFFECT.SPEED],
		sLW = effects_array[EFFECT.SLOW];

		ai_timer += timeDivisor*delta_time*DELTA_TO_SECONDS*((1 +sPD/5)/(1 +sLW/5))*global.level_speed/timerMultiplier;
		skip_timer = true;
		var Sound = snd_move;
		if PieceVictim != noone {
			Sound = snd_enemy_taking;
		}
		var sound_params = {
		sound: Sound,
		pitch: 1 +(ai_timer/TIMETOTAKE)/2,
		};		
		if !audio_is_playing(Sound){
			audio_play_sound_ext(sound_params);
		} 

	
		if ai_timer >= TIMETOTAKE {
			commitMove = true;
			ai_timer = 0;
		}							
	}
	// Now commit to making the move
	if commitMove {
		if PieceVictim != noone {
			// Deal Damage/Destroy Victim Piece
			with PieceVictim {
				global.enemy_turns -= Cost;	
				hp -= PieceEnemy.attack_power;
				if object_index == obj_hero_wall || hp > 0 {
					destroyEnemy = true;
				} else if hp <= 0 {
					instance_destroy();	
				}
			}			
		}
				
		// Deal with control piece
		with PieceEnemy {
			if destroyEnemy {
				instance_destroy();		
			} else {
				x = targetX -GRIDSPACE/2;
				y = targetY -GRIDSPACE/2;
				piece_on_grid = EnemyOnGrid; 
				grid_pos = EnemyPos;
				moved = true;
				move_count++;
			}
		}

	}	
}
}