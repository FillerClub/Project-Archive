var col = class,
textcol = c_white,
boxcol = draw_red_box?c_red:c_black;
if global.team == "friendly" {
	if global.turns < cost {
		textcol = c_red;	
	}
} else {
	if global.enemy_turns < cost {
		textcol = c_red;
	}
}

if cooldown < cooldown_length {
	textcol = c_red;
}
//draw slot background
draw_sprite_ext(spr_slot_bg,image_index,x,y,1,1,0,col,1);
//draw slot piece
draw_sprite(sprite_slot,0,x,y);
draw_sprite_ext(sprite_slot,0,x,y,1,1,0,#7DD3F9,highlight_alpha);
//draw slot frame
draw_sprite_ext(sprite_index,image_index,x,y,1,1,0,col,1);
//draw text indicating cost
draw_set_halign(fa_center); draw_set_valign(fa_middle); draw_set_color(textcol) draw_set_font(fnt_bit);
draw_text_transformed(x +41,y +58,string(cost),1,1,0);
draw_set_color(c_white) draw_set_font(fnt_fancy);
//draw_text_transformed(x + sprite_width/2,y + sprite_height*1.2 +x,string(identity[NAME]),.25,.25,0);
//draw cooldown shader
draw_set_alpha(0.5);
draw_set_color(boxcol);
var fillRect = lerp(bbox_bottom,bbox_top,1 -cooldown/cooldown_length)
if fillRect > 0 {
	draw_rectangle(bbox_left,fillRect,bbox_right,bbox_bottom,0);
}
draw_set_alpha(1);
draw_set_color(c_white);
if selected { draw_sprite(spr_slot_select,image_index,x,y);	}
