//draw slot piece
draw_sprite(sprite_slot,0,x,y);

var heroString = "";
with obj_generic_hero {
	if team == other.team {
		heroString = identity + "-" +other.identity;
	}
}


draw_sprite(spr_slot_frame,0,x,y);
//draw text indicating amount of powers

var textCol = (cooldown <= 0)?c_white:c_red;
draw_set_halign(fa_center); draw_set_valign(fa_middle); draw_set_color(textCol) draw_set_font(fnt_bit);
draw_text_transformed(x +41,y +58,cost,1,1,0);
draw_set_color(c_white) draw_set_font(fnt_fancy);
//draw_text_scribble(x,y,info);

//blackout if unusable
if cooldown > 0 {
	var fillRect = lerp(bbox_bottom,bbox_top,cooldown/cooldown_length),
	boxcol = draw_red_box?c_red:c_black;
	draw_set_alpha(.5);
	draw_set_color(boxcol);
	draw_rectangle(bbox_left,fillRect,bbox_right,bbox_bottom,0);
	draw_set_alpha(1);
	draw_set_color(c_white);
}