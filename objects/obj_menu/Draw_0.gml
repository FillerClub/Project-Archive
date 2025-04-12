/*
draw_set_font(font);
draw_set_halign(font_halign);
draw_set_valign(font_valign);

var gX = obj_cursor.x,
gY = obj_cursor.y,
menI = menu_index,
inputed = false,
mouseOnButton = position_meeting(gX,gY,button_object);

var
factX = menu_x,
factY = menu_y,
factS = 1,
factString = "Nothing";

for (var i = 0; i < array_length(menu[menu_index]) ; i++) {
	factY = menu_y +button_seperation*i;
	switch menu[menu_index][i] {		
		default:
			draw_set_color(current_index==i?text_selected_color:text_color);
			factString = manage_menu_text(menu[menu_index][i]);
			draw_text_transformed(factX,factY,factString,factS,factS,0);
		break;
		SLIDERS
			draw_set_color(current_index==i?text_selected_color:text_color);
			factString = manage_menu_text(menu[menu_index][i]);
			draw_text_transformed(factX,factY ,factString,factS,factS,0);
		break;
	}

}

//draw_text_scribble(room_width/2,room_height/2,position_meeting(gX,gY,button_object));