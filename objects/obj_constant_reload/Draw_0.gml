image_index = ammo;
var
rgbMax = 255,
col = make_color_rgb(rgbMax,draw_blue_green*rgbMax,draw_blue_green*rgbMax);

draw_sprite_ext(sprite_index,image_index,x,y,1,1,0,col,1);