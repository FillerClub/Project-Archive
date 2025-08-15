draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_tiny);
if info != 0 {
	var str = 
	string(info[$ "short_description"]) +"\nHP: " +string(info[$ "hp"]) + "\nCost: " +string(info[$ "place_cost"]) + "\nAttack Power: " +string(info[$ "attack_power"]);
	draw_text_transformed(x,y,str,1,1,0);
}