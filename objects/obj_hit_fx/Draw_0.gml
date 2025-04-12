var
xDiff = x_target -x,
yDiff = y_target -y;

x += xDiff/diff_factor;	
y += yDiff/diff_factor;
draw_set_font(fnt_tiny);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
if is_numeric(hp) {
	if sign(hp) < 0 {
		draw_set_color(c_red);
		draw_text_transformed(x,y,string(hp),image_xscale,image_yscale,0);
	}

	if sign(hp) > 0 {
		draw_set_color(c_green);
		draw_text_transformed(x,y,"+" + string(hp),image_xscale,image_yscale,0);
	}
} else {
	draw_text_transformed(x,y,string(hp),image_xscale,image_yscale,0);
}
