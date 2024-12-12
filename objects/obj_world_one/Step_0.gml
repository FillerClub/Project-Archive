var
gS = global.grid_spacing,
gD = global.grid_dimensions,
piece_present = false,
board_height = (gD[3] -gD[2])/gS,
random_y = 0,
reroll_y = true,
cycle_wall = 0;
random_time_add = 0;
//Detect enemy pieces
with obj_generic_piece {
	if team == global.enemy_team {
		piece_present = true
		other.last_piece_x = x;
		other.last_piece_y = y;
	} 
}
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
} until !reroll_y || cycle_wall <= 0
var accel = (!piece_present && phase >= 1);

/*
if phase >= FINALWAVE && timer[VICTORY] <= 0 {
	refer_database(display_identity);
	room_goto(rm_journal);
}
*/
/*
if variable_timer[VICTORY] > 0 {
	variable_timer[VICTORY] -= delta_time*DELTA_TO_SECONDS;	
}
if variable_timer[LEVELSTART] > 0 {
	variable_timer[LEVELSTART] -= delta_time*DELTA_TO_SECONDS;		
}
if variable_timer[FINALWAVE] > 0 {
	variable_timer[FINALWAVE] -= delta_time*DELTA_TO_SECONDS;		
}		
*/