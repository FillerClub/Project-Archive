var invert = false;

draw_self();

if draw_checker {
	for (var iY = y; position_meeting(x,iY,self); iY += GRIDSPACE) {
		if invert { invert = false } else { invert = true; }
		for (var iX = x; position_meeting(iX +GRIDSPACE*invert,y,self); iX += GRIDSPACE*2) {
			draw_set_color(c_white);
			draw_set_alpha(.05);
			draw_rectangle(iX +GRIDSPACE*invert,iY,iX +GRIDSPACE +GRIDSPACE*invert-1,iY +GRIDSPACE-1,0);
		}
	}
	draw_set_alpha(1);	
}
