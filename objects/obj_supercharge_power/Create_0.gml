aura =			[ [0, 1],
				[0, -1],
				[1, 0],
				[1, 1],
				[1, -1],
				[-1, 0],
				[-1, 1],
				[-1, -1],
				[0,0]];

var gS = global.grid_spacing;
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
					intangible = true;
					alarm[0] = game_get_speed(gamespeed_fps)*5.5;
					alarm[1] = 1;
				}
			}
		} 	
	}			
}

				
audio_play_sound(snd_beam,0,0);