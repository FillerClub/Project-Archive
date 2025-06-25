if input_mouse_check_pressed(mb_left) && position_meeting(mouse_x,mouse_y,self) {	
	var 
	ref = obj_server_manager,
	least = 0;
	if ref.running_matches > 0 {
		least = 1;	
	}
	if mouse_x < x {
		ref.match_index--;
	}
	
	if mouse_x > x {
		ref.match_index++;	
	}
	if ref.match_index > ref.running_matches {
		ref.match_index = least;
	}
	if ref.match_index < least {
		ref.match_index = ref.running_matches;
	}
}
x = obj_server_manager.x;