surface_set_target(global.gui_surface);
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
stringDraw = -1,
descWidth = 0,
descHeight = 0,
//shift = 10,
margin = 3;


// Draw health as popups
with instance_position(x,y,obj_generic_piece) {
	stringDraw = "HP: " +string(hp);
	descWidth = string_width(stringDraw);
	descHeight = string_height(stringDraw);
}
// Draw pop up descriptions from slots
with instance_position(x,y,obj_piece_slot) {
	stringDraw = desc;
	descWidth = string_width(stringDraw);
	descHeight = string_height(stringDraw);
}
// Draw power passive popup
with instance_position(x,y,obj_power_passive) {
	stringDraw = desc;
	descWidth = string_width(stringDraw);
	descHeight = string_height(stringDraw);
}

if stringDraw != -1 {
	draw_set_alpha(0.8);
	draw_set_color(c_black);
	draw_rectangle(x,y,x +descWidth +margin*2,y -descHeight -margin,false);
	draw_set_color(c_white);
	draw_text(x +margin,y -margin -4,stringDraw);	
}
surface_reset_target();