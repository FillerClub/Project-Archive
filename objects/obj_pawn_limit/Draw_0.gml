var
rgbMax = 255,
col = make_color_rgb(rgbMax,draw_blue_green*rgbMax,draw_blue_green*rgbMax);
draw_set_color(col);
draw_set_font(fnt_fancy);
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
draw_set_alpha(image_alpha);
var i = 0;

with obj_generic_piece {
	if team == global.team && object_get_parent(object_index) != obj_generic_hero_OLD {
		i++;	
	}
}


draw_text_transformed(x,y,string(i) + " / " + string(global.max_pawns),.5,.5,0); 
draw_set_alpha(1);