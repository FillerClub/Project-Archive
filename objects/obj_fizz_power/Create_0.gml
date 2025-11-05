aura =			[[0, 1],
				[0, -1],
				[1, 0],
				[-1, 0]];

var gS = GRIDSPACE;
var ar_leng = array_length(aura);
with instance_position(x,y,obj_generic_piece) {
	hurt(hp,2,DAMAGE.PHYSICAL,self);
	effect_generate(self,EFFECT.SLOW,"empress_poison",16,2);
	effect_generate(self,EFFECT.POISON,"empress_poison",9,1);
}

for (var i = 0; i < ar_leng; ++i)	{
	var xM = aura[i][0]*gS +x;
	var yM = aura[i][1]*gS +y;		
	// And if coords collide with obstacle/piece, draw RED. Else...
	if position_meeting(xM,yM,obj_generic_piece) {
		with instance_position(xM,yM,obj_generic_piece) {
			if team != other.team && !invincible {
				hurt(hp,1,DAMAGE.NORMAL,self);
			}
		}
	} 		
}
				
audio_play_sound(snd_poison_splash,0,0);
instance_destroy();