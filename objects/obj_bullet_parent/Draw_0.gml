var fakeHeight = z -GRIDSPACE/2;
draw_sprite(sprite_index,image_index,x,y -fakeHeight);
var shadowSize = 1/(max(0,log2(fakeHeight/64 +.5)) +2);
draw_sprite_ext(spr_shadow,0,x,y -(fakeHeight/1.5)*shadowSize +GRIDSPACE/2 ,.25,shadowSize,0,c_white,shadowSize*2);