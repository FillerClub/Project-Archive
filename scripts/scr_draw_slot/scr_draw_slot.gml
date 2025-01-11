function draw_slot(slot_index,col,textcol,cost, xoffset = 0, yoffset = 0) {
	//draw slot background
	draw_sprite_ext(spr_slot_bg,image_index,x +xoffset,y +yoffset,1,1,0,col,1);
	draw_set_color(c_white);
	//draw slot piece
	draw_sprite(slot_index,0,x +xoffset,y +yoffset);
	//draw slot frame
	draw_sprite_ext(sprite_index,image_index,x +xoffset,y +yoffset,1,1,0,col,1);
	//draw text indicating cost
	draw_set_halign(fa_center); draw_set_valign(fa_middle); draw_set_color(textcol) draw_set_font(fnt_bit);
	draw_text_transformed(x +41,y +58,string(cost),1,1,0);
	draw_set_color(c_white) draw_set_font(fnt_fancy);	
}