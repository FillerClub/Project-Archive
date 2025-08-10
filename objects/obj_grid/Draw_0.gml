var invert = invert_checker;
depth = -bbox_top +z +1000;
draw_sprite_ext(sprite_index,image_index,x,y -z,image_xscale,image_yscale,0,c_white,1);
if draw_checker {
	draw_set_color(c_black);
	draw_set_alpha(.27);
	for (var i = 0; i < image_yscale; i++) {
		invert = (i mod 2 == 0)?invert_checker:!invert_checker;
		for (var ii = 0; ii < image_xscale; ii++) {
			if invert {
				var rectX = x +GRIDSPACE*ii,
				rectY = y +GRIDSPACE*i -z;
				draw_rectangle(rectX,rectY,rectX +GRIDSPACE -1,rectY +GRIDSPACE -1,false);	
			}
			invert = !invert;
		}		
	}
	draw_set_alpha(1);	
}
	/*
	for (var iY = y; position_meeting(x,iY,self); iY += GRIDSPACE) {
		if invert == invert_checker { invert = false } else { invert = true; }
		for (var iX = x; position_meeting(iX +GRIDSPACE*invert,y,self); iX += GRIDSPACE*2) {
			draw_set_color(c_white);
			draw_set_alpha(.45);
			draw_rectangle(iX +GRIDSPACE*invert,iY -z,iX +GRIDSPACE +GRIDSPACE*invert-1,iY +GRIDSPACE-1 -z,0);
		}
	}
	*/