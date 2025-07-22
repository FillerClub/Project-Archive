var invert = false;
depth = -bbox_bottom +z;
draw_sprite_ext(sprite_index,image_index,x,y -z,image_xscale,image_yscale,0,c_white,1);
if draw_checker {
	for (var iY = y; position_meeting(x,iY,self); iY += GRIDSPACE) {
		if invert { invert = false } else { invert = true; }
		for (var iX = x; position_meeting(iX +GRIDSPACE*invert,y,self); iX += GRIDSPACE*2) {
			draw_set_color(c_white);
			draw_set_alpha(.05);
			draw_rectangle(iX +GRIDSPACE*invert,iY -z,iX +GRIDSPACE +GRIDSPACE*invert-1,iY +GRIDSPACE-1 -z,0);
		}
	}
	draw_set_alpha(1);	
}
