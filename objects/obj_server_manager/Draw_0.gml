draw_set_font(fnt_generic_dialogue);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_scribble(x,y +2,string(match_index) +" / " +string(running_matches));
draw_text_scribble(x,y +20,"Connected players: " +string(array_length(players)));
//draw_text(x,y +20,string(players));
draw_set_color(#00FF48);
draw_text_scribble(x,y -44,fps);
draw_text_scribble(x,y -23,fps_real);
camera_set_view_pos(view_camera[0],x -oX,0);

draw_text(x,y +360,"Packets Processed: " +string(packet_count));
//draw_text(x,y +392,"IP: " +string());