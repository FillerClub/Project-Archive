/// @desc Plays FX when destroyed
if asset_get_type(destroy_sound) == asset_sound {
	audio_stop_sound(destroy_sound);
	audio_play_sound(destroy_sound,0,0);
	var zOff = z;
	if instance_exists(piece_on_grid) {
		zOff += piece_on_grid.z;	
	}
	instance_create_layer(x,y -zOff,"Instances",obj_spr_particle, {
		sprite_index: spr_delete
	});
}

