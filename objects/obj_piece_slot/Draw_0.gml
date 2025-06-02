var col = class,
textcol = c_white,
boxcol = draw_red_box?c_red:c_black;
if global.player_team == "friendly" {
	if global.player_turns < cost {
		textcol = c_red;	
	}
} else {
	if global.opponent_turns < cost {
		textcol = c_red;
	}
}

if cooldown > 0 {
	textcol = c_red;
}

draw_slot(sprite_slot,col,textcol,cost);

//draw_text_transformed(x + sprite_width/2,y + sprite_height*1.2 +x,string(identity[PIECEDATA.NAME]),.25,.25,0);
//draw cooldown shader
draw_set_alpha(0.5);
draw_set_color(boxcol);
var fillRect = lerp(bbox_bottom,bbox_top,cooldown/cooldown_length)
if fillRect > 0 {
	draw_rectangle(bbox_left,fillRect,bbox_right,bbox_bottom,0);
}
draw_set_alpha(1);
draw_set_color(c_white);
if selected { draw_sprite(spr_slot_select,image_index,x,y);	}
