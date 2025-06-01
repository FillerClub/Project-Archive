with obj_generic_piece	{
	var globalDebugMode = global.debug;
	// Draw movement options
	if execute != "move" && globalDebugMode && ai_controlled { debugOn = true; } else
	if execute != "move" {
		continue;
	}
	var gX = obj_cursor.x,
	gY = obj_cursor.y,
	debugOn = false,
	colS = c_white,
	drawSpr = spr_grid_highlight;
	
	// Draw own square
	if debugOn {
		drawSpr = spr_grid_dotted; 
	}
	
	if position_meeting(gX,gY,self) && !debugOn {
		colS = c_red;
	}
		
	draw_sprite_ext(drawSpr,image_index,
		x,
		y,
		1,1,0,colS,1);
		
	var arrayLengthMovesList = array_length(valid_moves);
	// From each valid_moves array, grab each moves list (ONLY_ATTACK, ONLY_MOVE, BOTH)
	for (var list = 0; list < arrayLengthMovesList; list++) {
		// Filter out dead arrays
		if valid_moves[list] != undefined && valid_moves[list] != 0 {
			switch list {
				case ONLY_MOVE:
					highlight_draw(display_mode,valid_moves[ONLY_MOVE],c_aqua,globalDebugMode,PLACEABLEANY,PLACEABLENONE,false,false,debugOn);
				break;
				case ONLY_ATTACK:
					highlight_draw(display_mode,valid_moves[ONLY_ATTACK],c_red,globalDebugMode,PLACEABLENONE,DIFFERENT,false,false,debugOn)
				break;
				case BOTH:
					highlight_draw(display_mode,valid_moves[BOTH],c_white,globalDebugMode,PLACEABLEANY,DIFFERENT,false,false,debugOn)
				break;
			}
		}	
	}		
}
