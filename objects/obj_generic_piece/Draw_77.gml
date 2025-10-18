/// @desc Process animation change
if new_animation != -1 {
	var anim = layer_sequence_get_instance(animation),
	animTracks = anim.activeTracks,
	tracks = array_length(animTracks);
	ds_map_clear(interpolation_data);
	interpolation_lerp = 0;
	for (var t = 0; t < tracks; t++) {
	    create_piece_interpolation_data(animTracks[t],interpolation_data);
	}
	layer_sequence_destroy(animation);
	animation = layer_sequence_create("Instances",x +sprite_width/2,y +sprite_width/2,new_animation);
	new_animation = -1;
	if starting_sequence_pos != -1 {
		layer_sequence_headpos(animation,starting_sequence_pos);
		starting_sequence_pos = -1;
	} else {
		layer_sequence_headpos(animation,default_anim_position);
	}
}