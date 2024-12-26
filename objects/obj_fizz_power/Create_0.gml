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
		if position_meeting(xM,yM,obj_generic_piece) {
			with instance_position(xM,yM,obj_generic_piece) {
				if team != other.team && !intangible {
					effect_give(EFFECT.SLOW,30,1);
					effect_give(EFFECT.SLOW,12,2);
					effect_give(EFFECT.POISON,12,1);
				}
			}
		} 	
	}			
}
				
audio_play_sound(snd_poison_splash,0,0);
instance_destroy();