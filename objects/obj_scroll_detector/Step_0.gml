var mouseAction = mouse_wheel_up() -mouse_wheel_down()
if mouseAction != 0 {
	if mouse_over {
		with index_manager_link {
			if mouseAction {
				starting_index--;
			} else {
				starting_index++;	
			}
			update = true;
		}
	}
}
mouse_over = false;