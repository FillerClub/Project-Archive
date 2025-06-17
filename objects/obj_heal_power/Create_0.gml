with instance_position(x,y,obj_generic_piece) {
	hp = min(hp +5,hp_max);
	effect_generate(self,EFFECT.SPEED,9,3);
}
audio_play_sound(snd_shield_up,0,0);
instance_destroy();