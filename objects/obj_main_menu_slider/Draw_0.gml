if !instance_exists(obj_menu) {
	instance_destroy();	
	exit;
}
var knobObj = linked_object;
if sprite_index != spr_button {
	draw_self();
}
draw_sprite(knobObj.sprite_index,image_index,knobObj.x,knobObj.y);
draw_set_font(font);
draw_set_halign(font_halign);
draw_set_valign(font_valign);
draw_set_color(obj_menu.current_index==index?text_selected_color:text_color);
var factString = manage_menu_text(purpose);
draw_text(x,y -sprite_height/2 -12,factString);

