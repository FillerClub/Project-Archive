function hero_ai(){
// Generate random numbers
var
gS = GRIDSPACE,
gD = global.grid_dimensions,
board_height = (gD[3] -gD[2])/gS,
random_y = 0,
reroll_y = true,
cycle_wall = 0;
//Count amount of walls
with obj_hero_wall {
	if team == global.team {
		cycle_wall++;
	} 
}
// Find valid y
do {
	random_y = irandom_range(0,board_height);
	// Cycle through player's walls
	with obj_hero_wall {
		// If it is in position, has hp, and is player's, settle on this y
		if position_meeting(x,random_y*gS +gD[2],self) && hp > 0 && team == global.team {
			reroll_y = false
		}
	}
	cycle_wall--;
} until !reroll_y || cycle_wall <= -100
graphic_show = -1;
friendly_pieces = [];

for (var lanes = 0; lanes < (gD[3] -gD[2])/gS +1; lanes += 1) {
	row_value[lanes] = 0;
	row_threat[lanes] = 0;
}

//Grab all pieces on the board
var countFPiece = 0;
with obj_obstacle {
	if team == global.team && hp > 0 {
		other.friendly_pieces[countFPiece] = id;
		other.piece_value[countFPiece] = 0;
		countFPiece++;
	}
}

var tickRequest = false,
xRequest = x,
yRequest = y;
	
// Assign a value to friendly pieces
if countFPiece > 0 {
	var arrayFLength = array_length(friendly_pieces);
	for (var fPieces = 0; fPieces < arrayFLength; fPieces++) {
		var finst = friendly_pieces[fPieces],
		fX = (finst.x -gD[0] -gS)/(gD[1] -gD[0] -gS*2),
		fY = (finst.y -gD[2])/gS;
		switch finst.identity {
			case "short":
				if fY -2 >= 0 {
					row_threat[fY -2] += 1;
				}
				if fY -1 >= 0 {
					row_threat[fY -1] += 1;
				}
				row_value[fY] += lerp(1,5,fX);
				if fY +1 <= board_height {
					row_threat[fY +1] += 1;
				}
				if fY +2 <= board_height {
					row_threat[fY +2] += 1;
				}
			break;
				
			case "shooter":
				row_value[fY] += lerp(1,3,fX);
				row_threat[fY] += 2;
			break;
			
			case "splitter":
				row_value[fY] += lerp(1,6,fX);
				row_threat[fY] += 4;
			break;	
			
			case "big_shooter":
				row_value[fY] += lerp(1,12,fX);
				row_threat[fY] += 12;
			break;	
				
			case "stick":
				row_threat[fY] += 1;
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
maxValue = -1,
arLength = array_length(row_threat),
atIn = 0,
atFinalIn = 0,
at = [-1],
atFinal = [-1];

for (var itest = 0; itest < arLength; itest++) {
	if row_threat[itest] < minThreat {
		minThreat = row_threat[itest];	
	}
}

for (var iT = 0; iT < arLength; iT++) {
	if row_threat[iT] == minThreat {
		at[atIn] = iT;
		atIn++;
	}
}

if atIn > 1 {
	var arLength2 = array_length(at);
	for (var itest = 0; itest < arLength2; itest++) {
		if row_value[at[itest]] > maxValue {
			maxValue = row_value[at[itest]];	
		}
	}
	for (var iV = 0; iV < arLength2; iV++) {
		if row_value[at[iV]] == maxValue {
			atFinal[atFinalIn] = at[iV];
			atFinalIn++;
		}
	}		
} else {
	atFinal = at;	
}

if atFinal[0] = -1 {
	exit;	
} else {
// Else if there are multiple preferable moves
	var randRange = irandom(array_length(atFinal) -1);
	ai_lane_choose = atFinal[randRange];
}
}