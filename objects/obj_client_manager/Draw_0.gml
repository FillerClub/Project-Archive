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
	draw_text(room_width/2,room_height/2 +256,"Connecting" +bufferingString);
	
}
//draw_text(room_width/2,room_height/2 +256,string(debug));