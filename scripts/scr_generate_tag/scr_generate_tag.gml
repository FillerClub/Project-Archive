function generate_tag(characters = 4){
	var tag = string_random(4);
	with obj_obstacle {
		if tag == self.tag {
			tag = generate_tag(characters);	
		}
	}
	return tag;
}