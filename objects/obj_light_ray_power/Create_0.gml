var inst = instance_position(x,y,obj_generic_piece);
hurt(inst.hp,10,inst);
audio_play_sound(snd_zap,0,0);