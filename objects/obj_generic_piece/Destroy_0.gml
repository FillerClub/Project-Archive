/// @desc Plays FX when destroyed
audio_stop_sound(snd_delete);
audio_play_sound(snd_delete,0,0);
instance_create_layer(x,y,"Instances",obj_spr_particle, {
	sprite_index: spr_delete
});
