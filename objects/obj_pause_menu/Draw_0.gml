draw_set_font(fnt_phone);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_self();

if pause_toggle {
	draw_text_transformed(x,y +224,"PAUSED",1.5,1,0)	
}

