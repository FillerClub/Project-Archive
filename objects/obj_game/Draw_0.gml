draw_set_font(fnt_tiny);

//draw_text(room_width/2,room_height/2,string(lane_threat))	
//draw_text(room_width/2,room_height/2 +128,string(lane_score))	
if timer[ALERT] > 0 { draw_text_transformed(room_width/2,room_height -64,"Timer Up!",1,1,0); }
if global.debug {
	draw_set_halign(fa_left);
	draw_text_transformed(128,256,"FPS: " +string(fps_real),1,1,0);
	draw_text_transformed(128,256+32,string(ai_valid),1,1,0);
}


//draw_text(room_width/2,room_height/2,global.discovered_pieces);	
//draw_text(room_width/2,room_height/2 +32,string(on_pause_menu));	
//draw_text(room_width/2,room_height/2 +64,string(enable_pausing));	
//draw_text(room_width/2,room_height/2-64,string(lane_threat));	
