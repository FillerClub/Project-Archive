event_inherited();
var ar_leng = array_length(aura);

// For each move available (i)
if timer >= .5 {
	for (var i = 0; i < ar_leng; ++i) {
		if aura[i][0] == 0 && aura[i][1] == 0 {
			continue;	
		}
		var xM = aura[i][0]*GRIDSPACE +x;
		var yM = aura[i][1]*GRIDSPACE +y;		
		// If coords within move array are on the grid; 0 = x, 1 = y
		if place_meeting(xM,yM,obj_grid) {
			// And if coords collide with obstacle/piece, draw RED. Else...
			if place_meeting(xM,yM,obj_generic_piece) && !place_meeting(xM,yM,obj_cross) {
				with instance_position(xM,yM,obj_generic_piece) {
					if team == other.team {
						effect_give(EFFECT.SPEED,.5,2);	
					}
				}
			} 	
		}			
	}
	timer -= .5;
}


