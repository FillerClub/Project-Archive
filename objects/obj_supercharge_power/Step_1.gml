var gS = global.grid_spacing;
if !global.pause {
	timer += delta_time*DELTA_TO_SECONDS;
}
// Grab amount of valid moves
var ar_leng = array_length(aura);

// For each move available (i)
for (var i = 0; i < ar_leng; ++i)	{
	var xM = aura[i][0]*gS +x;
	var yM = aura[i][1]*gS +y;		
	// If coords within move array are on the grid; 0 = x, 1 = y
	if place_meeting(xM,yM,obj_grid) {
		
		// And if coords collide with obstacle/piece, draw RED. Else...
		if place_meeting(xM,yM,obj_generic_piece) && !place_meeting(xM,yM,obj_accelerator) {
			with instance_position(xM,yM,obj_generic_piece) {
				if team == other.team {
					spd += 18;
					//part_particles_burst(global.part_sys,x +8,y +8,part_debug);		
				}
			}
		} 	
	}			
}


if timer >= 5.5 {
	instance_destroy();	
}