var gS = global.grid_spacing;

grid_pos = [floor(x/gS),floor(y/gS)];

// Set up valid moves
valid_moves[BOTH] = [ [0, 1],
				[0, -1],
				[1, 0],
				[1, 1],
				[1, -1],
				[-1, 0],
				[-1, 1],
				[-1, -1],
				[0, 0]];
				
//depth -= 2;