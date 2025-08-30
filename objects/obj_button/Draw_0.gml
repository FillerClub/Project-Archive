if !instance_exists(obj_menu) {
	instance_destroy();	
	exit;
}
if sprite_index != spr_button {
	draw_self();
}
draw_set_font(font);
draw_set_halign(font_halign);
draw_set_valign(font_valign);
draw_set_color(obj_menu.current_index==index?text_selected_color:text_color);
var factString = manage_menu_text(purpose,context);
draw_text(x,y,factString);

