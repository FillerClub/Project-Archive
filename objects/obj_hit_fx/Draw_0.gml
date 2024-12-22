var
xDiff = x_target -x,
yDiff = y_target -y;

x += xDiff/32;	
y += yDiff/32;
draw_set_font(fnt_tiny);
if is_numeric(hp) {
	if sign(hp) < 0 {
		draw_set_color(c_red);
		draw_text_transformed(x,y,string(hp),1,1,0);
	}

	if sign(hp) > 0 {
		draw_set_color(c_green);
		draw_text_transformed(x,y,"+" + string(hp),1,1,0);
	}
} else {
	draw_text_transformed(x,y,string(hp),1,1,0);
}
draw_set_font(fnt_fancy);
draw_set_color(c_white);	