draw_set_font(fnt_basic);
var stringWidth = string_width(text),
stringHeight = string_height(text);
draw_set_alpha(.5);
draw_set_color(c_black);
draw_rectangle(x,y,x -stringWidth,y -stringHeight,false);
draw_set_halign(fa_right);
draw_set_valign(fa_middle);
draw_set_alpha(1);
draw_set_color(c_white);
draw_text_scribble(x,y,text);

