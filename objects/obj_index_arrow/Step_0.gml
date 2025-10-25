if mouse_on {
	repeat_timer += delta_time*DELTA_TO_SECONDS; 
} else {
	repeat_timer = 0;	
}
var timerCondition = repeat_timer >= .3
if mouse_pressed_on || timerCondition {
	if timerCondition {
		repeat_timer -= .1;	
	}
	with index_manager_link {
		if other.up {
			starting_index--;
		} else {
			starting_index++;	
		}
		update = true;
	}
}

mouse_on = false;
mouse_pressed_on = false;