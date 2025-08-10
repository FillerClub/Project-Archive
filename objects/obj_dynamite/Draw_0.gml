var fakeHeight = z,
zOff = 0;
if instance_exists(bullet_on_grid) {
	zOff += bullet_on_grid.z;
}
var shadowSize = 1/(max(0,log2((fakeHeight -zOff)/64 +.5)) +2);
draw_sprite_ext(spr_shadow,0,x,y -(fakeHeight/1.5)*shadowSize +GRIDSPACE/2 -zOff,1,shadowSize*3,0,c_white,shadowSize*2);
draw_sprite_ext(sprite_index,image_index,x,y -fakeHeight,image_xscale,image_yscale,image_angle,image_blend,image_alpha);