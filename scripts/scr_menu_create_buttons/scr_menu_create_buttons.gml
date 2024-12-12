// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function menu_create_buttons(){
	var alignButtonX = 0, 
	tempText = "Nothing",
	sizeButton = sprite_get_width(spr_button);
	prev_index = current_index;
	links[0] = noone;

	draw_set_font(font);
	switch font_halign {
		case fa_left:
			alignButtonX = 0;
		break;
			
		case fa_right:
			alignButtonX = sizeButton;
		break;
			
		default:
			alignButtonX = sizeButton/2;
		break;
	}
	sprite_set_offset(spr_button,alignButtonX,sizeButton/2)

	for (var i = 0; i < array_length(menu[menu_index]) ; i++) {
		with instance_create_layer(menu_x,menu_y +button_seperation*i,"GUI",obj_button, {
			purpose: menu[menu_index][i]
			}) {
			tempText = manage_menu_text(purpose);
			other.links[i] = self;
			image_xscale = (string_width(tempText) +other.button_width)/sizeButton;
			image_yscale = (string_height(tempText) +other.button_height)/sizeButton;
		}
	}
}