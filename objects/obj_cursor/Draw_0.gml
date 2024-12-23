if !using_mk && !instance_exists(obj_menu) {
	window_set_cursor(cr_none);
	draw_self();	
} else {
	window_set_cursor(cr_default);	
}

draw_set_color(c_white);
draw_set_font(fnt_bit);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
if global.mode = "delete" {
	draw_sprite(spr_remove_x,image_index,x-sprite_width/2,y-sprite_height/2);
}
var 
descDraw = -1,
descWidth = 0,
descHeight = 0,
//shift = 10,
margin = 3;
with instance_position(x,y,obj_piece_slot) {
	descDraw = desc;
	descWidth = string_width(descDraw);
	descHeight = string_height(descDraw);
}

if descDraw != -1 {
	draw_set_alpha(0.8);
	draw_set_color(c_black);
	draw_rectangle(x,y,x +descWidth +margin*2,y -descHeight -margin,false);
	draw_set_color(c_white);
	draw_text(x +margin,y -margin -4,descDraw);	
}