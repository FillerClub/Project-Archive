draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_tiny);
if info != 0 {
	var str = 
	string(info[PIECEDATA.BRIEFDESCRIPTION]) +"\nHP: " +string(info[PIECEDATA.HP]) + "\nCost: " +string(info[PIECEDATA.PLACECOST]) + "\nMovement Cost: " +string(info[PIECEDATA.MOVECOST]);
	draw_text_transformed(x,y,str,1,1,0);
}