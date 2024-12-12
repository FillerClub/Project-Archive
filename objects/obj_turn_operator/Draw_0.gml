var
rgbMax = 255,
col = make_color_rgb(rgbMax-draw_mute_red_green*200,draw_blue_green*rgbMax -draw_mute_red_green*30,draw_blue_green*rgbMax);
draw_sprite_ext(sprite_index,image_index,x,y,1,1,0,col,1);
//draw_mute_red_green = clamp(draw_mute_red_green -.02,0,1);