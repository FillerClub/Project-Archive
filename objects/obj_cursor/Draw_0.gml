if !using_mk && !instance_exists(obj_menu) {
	window_set_cursor(cr_none);
	draw_self();	
} else {
	window_set_cursor(cr_default);	
}

draw_set_color(c_white);
draw_set_font(fnt_bit);
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
if global.mode = "delete" {
	draw_sprite(spr_remove_x,image_index,x-sprite_width/2,y-sprite_height/2);
}