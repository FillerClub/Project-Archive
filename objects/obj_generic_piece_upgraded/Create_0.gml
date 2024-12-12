var gS = global.grid_spacing;
var tm = (team == "friendly")?1:-1;

valid_moves[BOTH] = [	[tm,1],
				[tm,0],
				[tm,-1],
				[0,0]];

grid_pos = [floor(x/gS),floor(y/gS)];

timer = timer_end*.75;	