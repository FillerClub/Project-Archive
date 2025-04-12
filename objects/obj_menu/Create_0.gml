//For save data info
savefile_exists = file_exists(SAVEFILE);
profile_exists = file_exists(PROFILE);

button_object = obj_button;
button_sprite = spr_button;
text_color = c_white;
text_selected_color = c_green;
min_width = 0;
slider_width = 3.5;
size_depends_on_text = true;
switch context {
	case MAIN:
		button_object = obj_main_menu_button;
		button_sprite = spr_main_button;
		text_selected_color = c_aqua;
	break;
	case PAUSE:
	case JOURNAL:
	case POSTLEVELJOURNAL:
		text_color = #73f597;
		slider_width = 5.5;
		text_selected_color = c_white;
	break;
}

menu_create_buttons();
