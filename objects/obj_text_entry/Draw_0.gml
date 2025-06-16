draw_set_font(fnt_basic);
blink += delta_time*DELTA_TO_SECONDS;
if blink >= .4 {
	toggle_underscore = (toggle_underscore == "_")?"  ":"_";	
	blink = 0;
}
text += keyboard_string;
if keyboard_string != "" {
	keyboard_string = "";
}
if keyboard_check_pressed(vk_backspace) {
	text = string_copy(text,1, string_length(text) -1)
}
var stringWidth = string_width(text)/2,
stringHeight = string_height(text)/2;
draw_set_alpha(.5);
draw_set_color(c_black);
draw_rectangle(room_width/2 -stringWidth -15,room_height/2 -stringHeight -10,room_width/2 +stringWidth +15,room_height/2 +stringHeight +10,false);
draw_set_alpha(1);
draw_set_color(c_white);
draw_text_scribble(room_width/2,room_height/2,text +toggle_underscore);

