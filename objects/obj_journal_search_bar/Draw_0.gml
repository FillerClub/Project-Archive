draw_set_font(fnt_tiny);
draw_set_valign(fa_middle);
draw_set_halign(fa_left);
draw_self();

if is_active {
    draw_set_color(c_white);
} else {
    draw_set_color(c_ltgray);
}

if !instance_exists(text_object_link) {
	draw_text(x,y,"MISSING TEXT OBJECT");
	exit;
}

var margin = 6;
var display_text = text;
var text_width = string_width(display_text);
var available_width = (bbox_right -bbox_left) -margin*2 -10;

while (text_width > available_width && string_length(display_text) > 0) {
    display_text = string_copy(display_text, 2, string_length(display_text) - 1);
    text_width = string_width(display_text);
}

// Draw cursor when active
if is_active {
	if cursor_visible {
		display_text += "|";	
	}
} else if display_text == "" {
	display_text = "Enter a piece's name here...";		
}
draw_text(text_object_link.x +margin,text_object_link.y -1,display_text);

