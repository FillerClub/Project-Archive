/// @desc Plays FX when destroyed
if asset_get_type(destroy_sound) == asset_sound {
	audio_stop_sound(destroy_sound);
	audio_play_sound(destroy_sound,0,0);
	var zOff = z;
	var gridOff = piece_on_grid;
	if is_string(gridOff) {
		with obj_grid {
			if tag == gridOff {
				zOff += z;
				break;
			}
		}
	} else if instance_exists(gridOff) { zOff += gridOff.z; }
	instance_create_layer(x,y -zOff,"Instances",obj_spr_particle, {
		sprite_index: spr_delete
	});
}

