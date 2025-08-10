var inst = instance_position(x,y,obj_generic_piece);
effect_generate(inst,EFFECT.OVERHEALTH,"warden_power_boost",9,5,noone);
effect_generate(inst,EFFECT.SPEED,"warden_power_boost",9,3,noone);
audio_play_sound(snd_shield_up,0,0);
instance_destroy();