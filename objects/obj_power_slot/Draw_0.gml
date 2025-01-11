//draw slot piece
draw_sprite(sprite_slot,0,x,y);



var heroString = "";
with obj_generic_hero {
	if team == other.team {
		heroString = identity + "-" +other.identity;
	}
}


draw_sprite(spr_power_slot_frame,0,x,y);
//draw text indicating amount of powers

var textCol = (usable > 0)?c_white:c_red;
draw_set_halign(fa_center); draw_set_valign(fa_middle); draw_set_color(textCol) draw_set_font(fnt_bit);
draw_text_transformed(x +39,y +58, "x" +string(usable),1,1,0);
draw_set_color(c_white) draw_set_font(fnt_fancy);
//draw_text(x,y,info);

//blackout if unusable
if usable <= 0 {
	draw_set_alpha(.5);
	draw_set_color(c_black);
	draw_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,0);
	draw_set_alpha(1);
	draw_set_color(c_white);
}