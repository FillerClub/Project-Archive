draw_set_font(font);
draw_set_halign(font_halign);
draw_set_valign(font_valign);
surface_set_target(global.gui_surface);
var
factX = menu_x,
factY = menu_y,
factS = 1,
factString = "Nothing";

for (var i = 0; i < array_length(menu[menu_index]) ; i++) {
	factY = menu_y +button_seperation*i;
	draw_set_color(current_index==i?c_green:c_white);
	factString = manage_menu_text(menu[menu_index][i]);
	draw_text_transformed(factX,factY,factString,factS,factS,0);
}
surface_reset_target();
//draw_text(room_width/2,room_height/2,string(current_index));