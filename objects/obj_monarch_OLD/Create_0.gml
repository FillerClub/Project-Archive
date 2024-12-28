var gS = GRIDSPACE;

grid_pos = [floor(x/gS),floor(y/gS)];

// Set up valid moves
valid_moves[BOTH] = [	[1,1],
					[1,-1],
					[-1,1],
					[-1,-1],
					[0,2],
					[2,0],
					[0,-2],
					[-2,0],
					[0,0]];
					
//depth -= 2;