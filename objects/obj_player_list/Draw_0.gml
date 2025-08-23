if steam_initialised() {
	draw_set_font(fnt_generic_dialogue);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
	if steam_lobby_list_is_loading() {
		draw_text(x,y,"Loading list of matches...");
	} else {
		var arLeng = array_length(lobby_list),
		drawString = "",
		yy = 0;
		for(var i = 0 ; i < arLeng; i++) {
			draw_set_color((i == index)?c_aqua:c_white);
			yy = i*20;
			drawString = string(lobby_list[i].name) + " - " +string(lobby_list[i].count) +"/8 players";
			draw_text(x,y +yy,drawString);
		}	
		if drawString == "" {
			drawString = "No matches are running."
			draw_text(x,y +yy,drawString);
		}
	}
}
//draw_text(x,y +60,lobby_list);