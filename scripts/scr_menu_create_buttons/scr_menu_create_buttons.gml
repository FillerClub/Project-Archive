function menu_create_buttons(){
	var alignButtonX = 0, 
	tempText = "Nothing",
	widthButton = sprite_get_width(button_sprite),
	heightButton = sprite_get_height(button_sprite);
	prev_index = current_index;
	links[0] = noone;

	draw_set_font(font);
	switch font_halign {
		case fa_left:
			alignButtonX = 0;
		break;
			
		case fa_right:
			alignButtonX = widthButton;
		break;
			
		default:
			alignButtonX = widthButton/2;
		break;
	}
	sprite_set_offset(button_sprite,alignButtonX,heightButton/2)
	

	var createObject = button_object;
	var createWidth = min_width;
	var textDep = size_depends_on_text;
	var origHeight = button_height;
	var newHeight = button_height;
	var finalXScale = 1;
	var finalYScale = 1;
	var useSprite = button_sprite;
	for (var i = 0; i < array_length(menu[menu_index]) ; i++) {
		tempText = manage_menu_text(menu[menu_index][i]);
		switch menu[menu_index][i] {
			SLIDERS
				createObject = obj_main_menu_slider;
				switch context {
					case JOURNAL:
					case PAUSE:
						useSprite = spr_pause_slider;
					break;
					default:
						useSprite = spr_main_slider;
					break;
				}
				createWidth = slider_width;
				textDep = false;
				finalXScale = slider_width;
				finalYScale = .5;
			break;
			default:
				createObject = button_object;
				createWidth = min_width;
				textDep = true;
				useSprite = button_sprite;
				finalXScale = max((string_width(tempText)*textDep +button_width)/widthButton,createWidth);
				finalYScale = max((string_height(tempText)*textDep +button_height)/heightButton,0);
			break;
		}
		with instance_create_layer(menu_x,menu_y +button_seperation*i,"GUI",createObject, {
			purpose: menu[menu_index][i],
			index: i,
			font: font,
			font_halign: font_halign,
			font_valign: font_valign,
			sprite_index: useSprite,
			image_xscale: finalXScale,
			image_yscale: finalYScale,	
			text_color: text_color,
			text_selected_color: text_selected_color,
			}) {
			other.links[i] = self;
		}
	}
}