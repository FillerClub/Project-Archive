/// @desc Process animation change
if new_animation != -1 {
	layer_sequence_destroy(animation);
	animation = layer_sequence_create("Instances",x +sprite_width/2,y +sprite_width/2,new_animation);
	new_animation = -1;
	if starting_sequence_pos != -1 {
		layer_sequence_headpos(animation,starting_sequence_pos);
		starting_sequence_pos = -1;
	}
}