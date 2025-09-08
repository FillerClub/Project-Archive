draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_fancy);
draw_set_color(c_white);
if alert_timer > 0 { draw_text_transformed(room_width/2,room_height -64,"Timer Up!",1,1,0); }