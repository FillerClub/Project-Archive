draw_set_halign(fa_left);
draw_set_font(fnt_tiny);
if connection_status == -1 {
	var cycleDots = timeout mod 1,
	bufferingString = ".";
	if cycleDots > .3 {
		bufferingString = "..";	
	}
	if cycleDots > .6 {
		bufferingString = "...";
	}
	draw_set_valign(fa_middle);
	draw_set_halign(fa_center);
	draw_text(128,room_height/2 +256,"Connecting" +bufferingString);
	
}
/*
for (var i = 0; i < array_length(players); i++) {
	draw_text(64,room_height/2 +256 +20*i,string(players[i]));	
}
//draw_text(room_width/2,room_height/2 +256,opponent_port);