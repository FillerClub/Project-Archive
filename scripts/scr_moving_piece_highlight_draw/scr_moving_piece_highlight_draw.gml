/// @description Draws on grid all valid moves provided, with extra functionality
/// @function scr_moving_piece_highlight_draw(valid_moves)

function scr_moving_piece_highlight_draw(valid_moves = [0,0]){
// Grab grid variables
var gS = global.grid_spacing,
gD = global.grid_dimensions,
gX = obj_cursor.x,
gY = obj_cursor.y;
can_move = true;

// Grab amount of valid moves
var ar_leng = array_length(valid_moves);

// For each move available (i)
for (var i = 0; i < ar_leng; ++i)	{
	if valid_moves[i][0] == 0 && valid_moves[i][1] == 0 {
		continue;	
	}
	var xM = valid_moves[i][0]*gS +x;
	var yM = valid_moves[i][1]*gS +y;		
	// If coords within move array are on the grid; 0 = x, 1 = y
	if place_meeting(xM,yM,obj_grid) {
		
		// And if coords collide with obstacle/piece, draw RED. Else...
		if place_meeting(xM,yM,obj_obstacle) {
			var col = c_red;
		} else { 
			
			// Convert mouse into simple grid coords
			var mosX = floor(gX/gS)*gS;
			var mosY = floor(gY/gS)*gS;
			
			// If mouse happens to be on valid move, draw AQUA. Else WHITE
			if (mosX == xM) && (mosY == yM) {
				var col = c_aqua;
			} else {
				var col = c_white; 
				}
			}
			
		// Draw valid moves on grid
		draw_sprite_ext(spr_grid_highlight,0,
		xM,
		yM,
		1,1,0,col,1);
		}		
	}
	
	draw_sprite_ext(spr_grid_highlight,0,
	x,
	y,
	1,1,0,c_white,1);
}
