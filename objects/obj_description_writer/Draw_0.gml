draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_font(fnt_tiny);
if info != 0 {
	draw_text_transformed(x,y,info[BRIEFDESCRIPTION],1,1,0);
	draw_text_transformed(x,y+32,"HP: " +string(info[HP]) + " Cost: " +string(info[PLACECOST]) + " Turn cost: " +string(info[MOVECOST]),1,1,0);
	draw_text_transformed(x,y+64,info[DESCRIPTION],1,1,0);
}