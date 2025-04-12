var gS = GRIDSPACE;
var gD = global.grid_dimensions;

if execute == "move" {
	draw_set_color(c_black);
	grid_highlight_draw(valid_moves[BOTH],PLACEABLEANY,DIFFERENT);
	draw_set_color(c_white);
} else {
	draw_set_color(c_white);	
}
/*
draw_text_scribble(x,y+64,string(floor(x/gS)*gS));
draw_text_scribble(x+64,y+64,string(floor(y/gS)*gS));

draw_text_scribble(x,y+96,valid_moves[1][0]);
draw_text_scribble(x+64,y+96,valid_moves[2][1]);
*/


if team == global.team {
	with obj_dummy {
		var 
		gClampX = floor(x/gS)*gS +gS/2,
		gClampY = floor(y/gS)*gS +gS/2;
		if position_meeting(gClampX,gClampY,obj_grid) {
			switch identity {
				case 2:
					if team == "friendly" { var tm = global.grid_dimensions[1] +gS; } else { var tm = global.grid_dimensions[0]; }
					draw_line_width(other.x +gS/2,other.y +gS/2,tm,other.y +gS/2,2)
					/*draw_set_color(c_red);
					draw_line(other.x +sprite_width/2,other.y +sprite_height/2,gClampX,gClampY);		
					*/
				break;
			}
		}
	}
}

piece_draw(true);
