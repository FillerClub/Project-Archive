draw_set_font(fnt_phone);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

var drawText = "No players online",
textCol = c_white;
if array_length(player) > 0 {
	for (var i = 0;i < array_length(player);i++) {
		switch status[i] {
			case ONLINESTATUS.IDLE:
				textCol = #515151;
			break;
			case ONLINESTATUS.MATCHHOST:
				textCol = #00FF48;
			break;
		}
		if i == index {
			textCol = c_aqua;	
		}
		drawText = string(player[i]) +" - " +status_int_to_string(status[i]);
		draw_set_color(textCol);
		draw_text(x,y +i*15,drawText);	
	}
} else {
	draw_text(x,y,drawText);	
}
//draw_text(x,y-14,string(players));