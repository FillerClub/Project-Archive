var
rgbMax = 255,
col = make_color_rgb(rgbMax-draw_mute_red_green*200,draw_blue_green*rgbMax -draw_mute_red_green*30,draw_blue_green*rgbMax);
draw_set_color(col);
draw_set_font(fnt_tiny);
//draw_set_halign((team == "friendly")?fa_left:fa_right);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
scr_draw_circle_part(x,y ,sprite_width/2,col,false,180,true,timer*(360/seconds_per_turn),360,1);

var str = string((team == "friendly")?global.turns:global.enemy_turns);
draw_text_transformed(x,y +sprite_height/2 +20,str,1.5,1.5,0);
var strWidth = string_width(str)*1.5;
var strHeight = string_height(str)*1.5;
draw_set_halign(fa_left);
draw_text_transformed(x +strWidth/2,y +sprite_height/2 +strHeight*.75,"/" +string(global.max_turns),1,1,0);
//draw_text_transformed((team == "friendly")?x+20:x-20,y,string((team == "friendly")?global.turns:global.enemy_turns),1,1,0);
//draw_text_scribble(x,y +64,temp_accel);
// Game timer upgrade bar
var barPerc = lerp(y +sprite_height/2,y -sprite_height/2,max(obj_game.timer[MAIN]/TIMERUPLENGTH,0));

if team == "friendly" {
	draw_set_color(c_black);
	draw_rectangle(x -sprite_width/2 -16,y +sprite_height/2,x -sprite_width/2 -8,y -sprite_height/2,false);
	draw_set_color(c_aqua);
	draw_rectangle(x -sprite_width/2 -16,y +sprite_height/2,x -sprite_width/2 -8,barPerc,false);
} else {
	draw_set_color(c_black);
	draw_rectangle(x +sprite_width/2 +8,y +sprite_height/2,x +sprite_width/2 +16,y -sprite_height/2,false);
	draw_set_color(c_aqua);
	draw_rectangle(x +sprite_width/2 +8,y +sprite_height/2,x +sprite_width/2 +16,barPerc,false);
}

spd = 0;

//draw_text_scribble(x,y-128,obj_game.timer[MAIN]);