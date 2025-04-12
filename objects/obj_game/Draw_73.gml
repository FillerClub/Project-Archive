var num = instance_number(obj_text_box);
if num > 1 {
	var 
	bubble_col = c_white,
	text_col = c_black,
	drawX = -128,
	drawY = -128;
	with obj_text_box {
		if priority == 0 {
			drawX = x -lerp(1,(room_width)/2,lerp_var) +sprite_width/2 -5;
			drawY = y +scribble_object[text_index].get_height()/2 -30;
			bubble_col = bubble_color;
			text_col = text_color;
			draw_set_font(fnt_generic_dialogue);
			draw_set_halign(fa_center);
			draw_set_valign(fa_middle);
			scribble_color_set(c_white);
			draw_sprite_ext(spr_small_speech_bubble,image_index,drawX,drawY,1,1,0,bubble_col,1);
			draw_text_scribble(drawX,drawY,"!");
		}
	}
}