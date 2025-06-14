var gS = GRIDSPACE;

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


if team == global.player_team {
	with obj_dummy {
		var 
		gClampX = floor(x/gS)*gS +gS/2,
		gClampY = floor(y/gS)*gS +gS/2;
		if position_meeting(gClampX,gClampY,obj_grid) {
			if 	sprite_index == spr_generic_power_3 {
				draw_set_color(c_red);
				draw_line(other.x +sprite_width/2,other.y +sprite_height/2,gClampX,gClampY);	
			}
		}

	}
}
//draw_text_scribble(x,y+64,string(slw));
piece_draw(true);
/*
if team == "enemy" {
	draw_sprite_ext(sprite_index,0,x,y,1,1,0,c_red,(intangible)?0.5:1);
} else {
	
}
