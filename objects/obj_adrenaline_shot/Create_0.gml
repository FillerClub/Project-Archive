var own = noone;
with obj_constant_reload {
	if team == other.team {
		own = self;	
	}
}
if !instance_exists(own) {
	instance_destroy();
	exit;
}
if own.ammo <= 0 {
	instance_destroy();	
}
with obj_generic_piece {
	if team == other.team {
		effect_generate(self,EFFECT.OVERHEALTH,string_random(3),1,5,noone,true);
		effect_generate(self,EFFECT.SPEED,"Adrenaline",1,1,noone);
	}
}
own.ammo--;
audio_play_from_array([snd_lonestar_gunshot_1,snd_lonestar_gunshot_2,snd_lonestar_gunshot_3]);
instance_destroy();