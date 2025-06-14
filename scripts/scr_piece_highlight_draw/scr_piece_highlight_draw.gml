/// @description Draws on grid where piece could be placed and if it can
/// @function scr_piece_highlight_draw();
function piece_highlight_draw(){
// Grab grid variables
can_move = true;


// If it's not placed
if fresh {
	// Convert object being dragged to simple grid coords
	var gcX = floor(x/GRIDSPACE)*GRIDSPACE;
	var gcY = floor(y/GRIDSPACE)*GRIDSPACE;
	
	// If position is on the grid
	if position_meeting(gcX,gcY,obj_grid) {
		if place_method == PIECE {
			if !position_meeting(gcX,gcY,(team == "friendly")?obj_territory_friendly:obj_territory_enemy) {
				draw_sprite_ext(
				spr_grid_highlight,0,
				gcX,
				gcY,
		//		clamp(grid_pos[0]*GRIDSPACE,gD[0],gD[1]),
		//		clamp(grid_pos[1]*GRIDSPACE,gD[2],gD[3]),
				1,1,0,c_red,1
				)
				exit;
			}
		}

		// And if it's not on obstacle, draw AQUA. Else, draw RED
		if !position_meeting(gcX,gcY,obj_obstacle) {
			draw_sprite_ext(
			spr_grid_highlight,0,
			gcX,
			gcY,
	//		clamp(grid_pos[0]*GRIDSPACE,gD[0],gD[1]),
	//		clamp(grid_pos[1]*GRIDSPACE,gD[2],gD[3]),
			1,1,0,c_aqua,1
			)				
		} else {
			draw_sprite_ext(
			spr_grid_highlight,0,
			gcX,
			gcY,
	//		clamp(grid_pos[0]*GRIDSPACE,gD[0],gD[1]),
	//		clamp(grid_pos[1]*GRIDSPACE,gD[2],gD[3]),
			1,1,0,c_red,1
			)
			}
		}
	}
}