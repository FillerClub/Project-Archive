sprite_index = hero_database(player.hero,HERODATA.SPRITE);
draw_self();
draw_set_font(fnt_tiny);
draw_set_valign(fa_middle);
draw_set_halign(fa_center);
draw_set_color(c_white);
draw_text(x,y-16,string(player.name));
draw_text(x,y,"Port: " +string(player.port));
var stringDraw = status_int_to_string(player.status);
draw_text(x,y+16,stringDraw);
draw_text(x,y+32,string(player.loadout));

if instance_exists(player.match) {
	draw_set_color(#1CFF7A);
	draw_line_width(x,y,player.match.x,player.match.y,3);	
}
