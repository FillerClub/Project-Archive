function draw_menu_button_text(offset_y = 0, offset_x = 0){
	draw_self();

	draw_set_font(font);
	draw_set_halign(font_halign);
	draw_set_valign(font_valign);
	draw_set_color(obj_menu.current_index==index?text_selected_color:text_color);
	var factString = manage_menu_text(purpose);
	draw_text(x +offset_x,y +offset_y,factString);

}