draw_self();
if timer > 0 {
	draw_set_color(c_black);
	draw_set_alpha(.5);
	draw_rectangle(x,y,x+sprite_width,y+(sprite_height -(sprite_height*(timer/5))),false);	
	draw_set_alpha(1);
}