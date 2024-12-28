var gS = GRIDSPACE;
var gD = global.grid_dimensions;
var invert = false;

draw_self();

for (var iY = y; position_meeting(x,iY,self); iY += gS) {
	if invert { invert = false } else { invert = true; }
	for (var iX = x; position_meeting(iX +gS*invert,y,self); iX += gS*2) {
		draw_set_color(c_white);
		draw_set_alpha(.05);
		draw_rectangle(iX +gS*invert,iY,iX +gS +gS*invert-1,iY +gS-1,0);
	}
}
draw_set_alpha(1);