draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_tiny);
if info != 0 {
	var str = 
	string(info[BRIEFDESCRIPTION]) +"\nHP: " +string(info[HP]) + "\nCost: " +string(info[PLACECOST]) + "\nMovement Cost: " +string(info[MOVECOST]) +"\n" +string(info[DESCRIPTION]);
	draw_text_transformed(x,y,str,1,1,0);
}