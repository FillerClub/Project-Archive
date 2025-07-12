function hero_ai() {
// Generate random numbers
var gridRef = noone;
with obj_grid {
	if team == global.opponent_team {
		gridRef = self;
	}
}
var
board_height = (gridRef.bbox_bottom -gridRef.bbox_top)/GRIDSPACE;

for (var lanes = 0; lanes < board_height +1; lanes += 1) {
	row_value[lanes] = 0;
	row_threat[lanes] = 0;
}

//Grab all pieces on the board
var countFPiece = 0;
with obj_obstacle {
	if team == global.player_team && hp > 0 {
		other.friendly_pieces[countFPiece] = id;
		other.piece_value[countFPiece] = 0;
		countFPiece++;
	}
}
var arrayFLength = array_length(friendly_pieces);
var tickRequest = false,
xRequest = x,
yRequest = y,
hero = "n/a",
powersAvailable = [0,0,0];

timer_power += delta_time*DELTA_TO_SECONDS*timer_mod*(1 +hero_phase/9)*global.level_speed;	

with obj_power_slot {
	if team == "enemy" {
		switch identity {
			case "a":
				powersAvailable[0] = (cooldown <= 0 && usable)?true:false;
			break;
			
			case "b":
				powersAvailable[1] = (cooldown <= 0 && usable)?true:false;
			break;
			
			case "c":
				powersAvailable[2] = (cooldown <= 0 && usable)?true:false;
			break;
		}
	}
}
with obj_generic_hero {
	if team == "enemy" {
		hero = identity;
	}
}

if timer_power >= timer_power_end {
	timer_power -= timer_power_end;	
	timer_power_end = random_percent(3.5,30); 
	// Power manager
	switch hero {
		case "Empress":
			if powersAvailable[0] == true {
				var doesBreak = false;
				for (var fNet = 0; fNet < arrayFLength; fNet++) {
					var inst = friendly_pieces[fNet],
					instX = inst.x,
					instY = inst.y,
					toX = undefined,
					toY = undefined,
					skipPiece = false;
					switch inst.identity {
						case "hero_wall":
						case "stick":
						case "super_stick":
							skipPiece = true;
						break;
						default:
							//Run code
						break;
					}
					if skipPiece {
						continue;	
					}
					with obj_generic_piece {
						if team == inst.team || distance_to_object(inst) > GRIDSPACE*2 {
							continue;	
						}
						// Determine how it can use net.
						switch identity {
							case "crawler":
							case "tank_crawler":
							case "super_tank_crawler":
							case "drooper":
							case "the_goliath":
								toX = x +tm_dp(1,team,toggle)*GRIDSPACE;
								toY = y;
								if position_meeting(toX,toY,obj_obstacle) || !position_meeting(toX,toY,obj_grid) {
									toX = undefined;
									toX = undefined;
								}
							break;

								
							default:
								// Do nothing
							break;
						}
					}
					if toX != undefined && toY != undefined {
						with inst {
							repeat(45) {
								part_particles_burst(global.part_sys,x,y,part_slap);		
							}	
							audio_play_sound(snd_oip,0,0);
							x = toX;
							y = toY;
							doesBreak = true;
						}
					}
					if doesBreak { 
						with obj_power_slot {
							if team == "enemy" && identity == "a" {
								cooldown = cooldown_length;	
							}
						}
						break; 
					}
				}	
				if doesBreak { break; }
			}
			
			if powersAvailable[1] == true {
				var doesBreak = false;
				for (var fSplash = 0; fSplash < arrayFLength; fSplash++) {
					var inst = friendly_pieces[fSplash],
					instX = inst.x,
					instY = inst.y,
					worthScore = 0,
					countPiece = countFPiece;

					repeat countFPiece{
						with collision_rectangle(instX -GRIDSPACE,instY -GRIDSPACE,instX +GRIDSPACE,instY +GRIDSPACE,friendly_pieces[countPiece -1],false,true) {
							// Determine if worth slowing down.
							switch identity {
								case "accelerator":
								case "wall":
								case "super_stick":
								case "stick":
								case "cross":
								case "hero_wall":
									// Ignore
								break;
								case "short":
									if decide_shoot && effects_array[EFFECT.SLOW] < 3 {
										worthScore += 2;	
									}
								break;
								
								default:
									if effects_array[EFFECT.SLOW] < 3  {
										worthScore += 1;	
									}
								break;
							}
						}	
						countPiece--;
					}

					if worthScore >= 2 {
						instance_create_layer(instX,instY,"Instances",obj_fizz_power,{
							team: "enemy",
							ai_controlled: true
						});	
						with obj_power_slot {
							if team == "enemy" && identity == "b" {
								cooldown = cooldown_length;	
							}
						}
						global.opponent_turns--;
						doesBreak = true;
						break;
					}
				}
				if doesBreak { break; }
			}
			if powersAvailable[2] == true {
				if !position_meeting(960,320,obj_obstacle) && !position_meeting(960,448,obj_obstacle) {
					instance_create_layer(0,384,"Instances",obj_horde_power,{
						team: "enemy",
						ai_controlled: true
					});	
					with obj_power_slot {
						if team == "enemy" && identity == "c" {
							cooldown = cooldown_length;		
						}
					}
					global.opponent_turns--;
					break;
				}
			}
		break;
		default:
			// No powers to use.
		break;
	}
}

// Assign a value to friendly pieces
if countFPiece > 0 {
	for (var fPieces = 0; fPieces < arrayFLength; fPieces++) {
		var finst = friendly_pieces[fPieces],
		fX = (finst.x -gridRef.bbox_left -GRIDSPACE)/(gridRef.bbox_right -gridRef.bbox_left -GRIDSPACE*2),
		fY = (finst.y -gridRef.bbox_top)/GRIDSPACE;
		switch finst.identity {
			case "short":
				if fY -2 >= 0 {
					row_value[fY -2] -= 1;
				}
				if fY -1 >= 0 {
					row_value[fY -1] -= 1;
				}
				row_value[fY] += lerp(1,5,fX);
				if fY +1 <= board_height {
					row_value[fY +1] += 1;
				}
				if fY +2 <= board_height {
					row_value[fY +2] += 1;
				}
			break;
				
			case "shooter":
				row_value[fY] += lerp(1,3,fX);
				row_threat[fY] += 2;
			break;
			
			case "double_shooter":
				row_value[fY] += lerp(1,6,fX);
				row_threat[fY] += 4;
			break;	
			
			case "big_shooter":
				row_value[fY] += lerp(1,12,fX);
				row_threat[fY] += 12;
			break;	
				
			case "stick":
				row_value[fY] -= 1;
			break;
			case "super_stick":
				if fY -2 >= 0 {
					row_threat[fY -2] += 2;
				}
				if fY -1 >= 0 {
					row_threat[fY -1] += 2;
				}
				row_threat[fY] += 2;
				if fY +1 <= board_height {
					row_threat[fY +1] += 2;
				}
				if fY +2 <= board_height {
					row_threat[fY +2] += 2;
				}
			break;
			case "cross":
				row_value[fY] += lerp(5,8,fX);
			break;				
			case "hero_wall":
				row_value[fY] += 5;
			break;
			case "piercer":
				row_value[fY] += lerp(1,6,fX);
				row_threat[fY] += 1;
			break;
			case "accelerator":
				row_value[fY] += lerp(3,5,fX);
			break;
				
			default: 
				row_value[fY] += lerp(1,3,fX);
				row_threat[fY] += lerp(3,1,fX);
			break;	
		}
	}
}
var minThreat = 9999,
maxThreat = -1,
maxValue = -1,
arLength = array_length(row_threat),
atChoose = [-1],
atChooseIn = 0,
atProtect = [-1],
atProtectIn = 0,
atChooseFinalIn = 0,
atChooseFinal = [-1],
atProtectFinal = [-1];

for (var itest = 0; itest < arLength; itest++) {
	if row_threat[itest] < minThreat {
		minThreat = row_threat[itest];	
	}
	if row_threat[itest] > maxThreat {
		maxThreat = row_threat[itest];	
	}
}

for (var iT = 0; iT < arLength; iT++) {
	if row_threat[iT] == minThreat {
		atChoose[atChooseIn] = iT;
		atChooseIn++;
	}
	if row_threat[iT] == maxThreat {
		atProtect[atProtectIn] = iT;
		atProtectIn++;
	}
}


if atChooseIn > 1 {
	var arLength2 = array_length(atChoose);
	for (var itest = 0; itest < arLength2; itest++) {
		if row_value[atChoose[itest]] > maxValue {
			maxValue = row_value[atChoose[itest]];	
		}
	}
	for (var iV = 0; iV < arLength2; iV++) {
		if row_value[atChoose[iV]] == maxValue {
			atChooseFinal[atChooseFinalIn] = atChoose[iV];
			atChooseFinalIn++;
		}
	}		
} else {
	atChooseFinal = atChoose;	
}
var randProtectRange = irandom(array_length(atProtect) -1);

ai_lane_protect = atProtect[randProtectRange];

if atProtectIn > 1 && atProtectIn < 5 {
	should_protect = true;
} else {
	should_protect = false;	
}

if atChooseFinal[0] = -1 {
	exit;	
} else {
// Else if there are multiple preferable moves
	var randRange = irandom(array_length(atChooseFinal) -1);
	ai_lane_choose = atChooseFinal[randRange];
}
}
/*
	instance_create_layer(room_width/2,room_height/2,"GUI",obj_hit_fx, {
		hp: ai_lane_protect,
		x_target: room_width/2,
		y_target: room_height/2,
		diff_factor: 1
	});
	instance_create_layer(room_width/2,room_height/2 +32,"GUI",obj_hit_fx, {
		hp: ai_lane_choose,
		x_target: room_width/2,
		y_target: room_height/2 +32,
		diff_factor: 1,
	});