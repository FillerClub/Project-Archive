var gS = GRIDSPACE;
var ar_leng = array_length(aura);
for (var i = 0; i < ar_leng; ++i)	{
	var xM = aura[i][0]*gS +x;
	var yM = aura[i][1]*gS +y;		
	// If coords within move array are on the grid; 0 = x, 1 = y
	if place_meeting(xM,yM,obj_grid) {
		
		// And if coords collide with obstacle/piece, draw RED. Else...
		if place_meeting(xM,yM,obj_generic_piece) && !place_meeting(xM,yM,obj_accelerator) {
			var col = c_aqua;
		} else { 
			var col = c_white;
		}
			
		// Draw valid moves on grid
		draw_sprite_ext(spr_aura,0,
		xM,
		yM,
		1,1,0,col,1);
	}		
}

draw_self();