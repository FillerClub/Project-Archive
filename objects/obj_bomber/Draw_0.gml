var
gS = GRIDSPACE,
gX = obj_cursor.x,
gY = obj_cursor.y,
gCX = floor(gX/gS)*gS,
gCY = floor(gY/gS)*gS;
if !skip_move {
	switch execute {
		case "move":
			var col = c_white;
			if position_meeting(gCX,gCY,obj_grid) {
				if position_meeting(gCX,gCY,obj_generic_piece) {
					with instance_position(gCX,gCY,obj_generic_piece) {
						if team == other.team {
							col = c_red	
						} else if team != other.team && hp > 0 && !intangible {
							col = c_aqua;	
						}
					}
				} 
				draw_sprite_ext(spr_grid_highlight,image_index,gCX,gCY,1,1,0,col,1);
			}
			draw_sprite(spr_grid_target,image_index,gX,gY);
		break;
	}
}
event_inherited();
