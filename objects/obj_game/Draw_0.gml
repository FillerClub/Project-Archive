draw_set_font(fnt_tiny);

//draw_text_scribble(room_width/2,room_height/2,string(lane_threat))	
//draw_text_scribble(room_width/2,room_height/2 +128,string(lane_score))	
if global.debug {
	draw_set_halign(fa_left);
	draw_text_transformed(64,256,"FPS: " +string(fps_real),1,1,0);
}

//draw_text_scribble(room_width/2,room_height/2 +128,string(instance_exists(noone)));	
draw_text_scribble(room_width/2,room_height -128,global.game_state);	
//draw_text_scribble(room_width/2,room_height/2 +32,string(global.unlocked_pieces));	
//draw_text_scribble(room_width/2,room_height/2 +64,string(enable_pausing));	
//draw_text_scribble(room_width/2,room_height/2-64,string(lane_threat));	
