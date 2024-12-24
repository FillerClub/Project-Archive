//draw slot piece
draw_sprite(sprite_slot,0,x,y);

//blackout if unusable
if !usable {
	draw_set_alpha(.5);
	draw_set_color(c_black);
	draw_rectangle(bbox_left,bbox_top,bbox_right,bbox_bottom,0);
	draw_set_alpha(1);
	draw_set_color(c_white);
}

var heroString = "";
with obj_generic_hero {
	if team == other.team {
		heroString = identity + "-" +other.identity;
	}
}

draw_sprite(spr_power_slot_frame,0,x,y);

//draw_text(x,y,info);