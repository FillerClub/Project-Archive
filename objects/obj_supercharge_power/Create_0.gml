aura =			[ [0, 1],
				[0, -1],
				[1, 0],
				[1, 1],
				[1, -1],
				[-1, 0],
				[-1, 1],
				[-1, -1],
				[0,0]];

var gS = GRIDSPACE;
// Grab amount of valid moves
var ar_leng = array_length(aura);

// For each move available (i)
for (var i = 0; i < ar_leng; ++i)	{
	var xM = aura[i][0]*gS +x;
	var yM = aura[i][1]*gS +y;		
	// And if coords collide with obstacle/piece, draw RED. Else...
	if position_meeting(xM,yM,obj_generic_piece) {
		var instMeet = instance_position(xM,yM,obj_generic_piece);
		if instMeet.team == team {
			effect_generate(instMeet,EFFECT.SPEED,"warden_power_super",5.5,10);
			effect_generate(instMeet,EFFECT.INTANGIBILITY,"warden_power_super",5.5,1);
		} 	
	}			
}

time_source_lol = time_source_create(time_source_game,5.5,time_source_units_seconds,function() {
	time_source_destroy(time_source_lol);
	instance_destroy();	
})	
time_source_start(time_source_lol);
audio_play_sound(snd_beam,0,0);