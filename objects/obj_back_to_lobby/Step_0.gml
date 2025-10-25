if input_mouse_check_pressed(mb_left) && position_meeting(mouse_x,mouse_y,self) {	
	randomise();
	var seed = random_get_seed();
	var tags = generate_tag_list(8);
	steam_relay_data({Message: SEND.READY, level_seed: random, random_object_tags: tags});
}