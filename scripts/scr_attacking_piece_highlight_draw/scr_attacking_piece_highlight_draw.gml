/// @description Draws on grid all valid moves provided, with extra functionality
/// @function scr_moving_piece_highlight_draw(valid_moves)

function scr_attacking_piece_highlight_draw(valid_attacks = [0,0]){



// Grab grid variables
var gS = GRIDSPACE,
gD = global.grid_dimensions,
gX = obj_cursor.x,
gY = obj_cursor.y;

can_move = true;

// Grab amount of valid moves
var ar_leng = array_length(valid_attacks);

// For each move available (i)
for (var i = 0; i < ar_leng; ++i)	{
	if valid_attacks[i][0] == 0 && valid_attacks[i][1] == 0 {
		continue;	
	}	
	var alph = 1
	var xA = valid_attacks[i][0]*gS +x;
	var yA = valid_attacks[i][1]*gS +y;
	
	// If coords within move array are on the grid; 0 = x, 1 = y
	if position_meeting(xA,yA,obj_grid) {
		var can_attack = false;
		if position_meeting(xA,yA,obj_obstacle) {
			var instattack = instance_position(xA,yA,obj_obstacle);
			if instattack.team != team && instattack.hp > 0 {
				can_attack = (!instattack.intangible);	
				alph = 1;
			}
		}
		
		// And if coords collide with obstacle/piece, draw RED. Else...
		if !can_attack {
			var col = c_red;
		} else { 
			
			// Convert mouse into simple grid coords
			var mosX = floor(gX/gS)*gS;
			var mosY = floor(gY/gS)*gS;
			
			// If mouse happens to be on valid move, draw AQUA. Else WHITE
			if (mosX == xA) && (mosY == yA) {
				var col = c_aqua;
			} else {
				var col = c_white; 
				}
			}
			
		// Draw valid moves on grid
		draw_sprite_ext(spr_grid_highlight,0,
		xA,
		yA,
		1,1,0,col,alph);
		}		
	}
	draw_sprite_ext(spr_grid_highlight,0,
	x,
	y,
	1,1,0,c_white,1);	
	
}
