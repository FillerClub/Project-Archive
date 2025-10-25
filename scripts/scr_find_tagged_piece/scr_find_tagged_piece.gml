function find_tagged_piece(tag){
	var returnInstance = noone;
	with obj_obstacle {
		if self.tag == tag {
			returnInstance = id;
			break;
		}
	}
	return returnInstance;
}