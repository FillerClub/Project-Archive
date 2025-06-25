if keyboard_check_pressed(vk_backspace) {
	index--;
	if index < 0 {
		instance_destroy();	
	}
	y = (index +1)*y_spread
}