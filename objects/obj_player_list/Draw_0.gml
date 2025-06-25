draw_set_font(fnt_phone);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
players = obj_client_manager.players;
var drawText = "No players online",
textCol = c_white;
if array_length(players) > 0 {
	for (var i = 0;i < array_length(players);i++) {
		switch players[i].status {
			case ONLINESTATUS.IDLE:
				textCol = #515151;
			break;
			case ONLINESTATUS.OPENLOBBY:
				textCol = #00FF48;
			break;
		}
		if i == index {
			textCol = c_aqua;	
		}
		drawText = players[i].name +" - " +status_int_to_string(players[i].status);
		draw_set_color(textCol);
		draw_text(x,y +i*14,drawText);	
	}
} else {
	draw_text(x,y,drawText);	
}
//draw_text(x,y-14,string(players));