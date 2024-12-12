aura =			[ [0,0], 
				[0, 1],
				[0, -1],
				[1, 0],
				[1, 1],
				[1, -1],
				[-1, 0],
				[-1, 1],
				[-1, -1]];

var gS = global.grid_spacing;
var ar_leng = array_length(aura);

for (var i = 0; i < ar_leng; ++i)	{
	var xM = aura[i][0]*gS +x;
	var yM = aura[i][1]*gS +y;		
	// If coords within move array are on the grid; 0 = x, 1 = y
	if place_meeting(xM,yM,obj_grid) {
		
		// And if coords collide with obstacle/piece, draw RED. Else...
		if place_meeting(xM,yM,obj_generic_piece) && !place_meeting(xM,yM,obj_accelerator) {
			with instance_position(xM,yM,obj_generic_piece) {
				if team != other.team {
					slw += 3;
					hp -= 3;
				}
			}
		} 	
	}			
}
				
audio_play_sound(snd_poison_splash,0,0);
instance_destroy();