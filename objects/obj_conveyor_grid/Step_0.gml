if place_meeting(x,y,obj_conveyor) {
	with instance_place(x,y,obj_conveyor) {
		if !start {
			instance_destroy(other);	
		}
	}
}

x += delta_time*DELTA_TO_SECONDS*speed_h;
y += delta_time*DELTA_TO_SECONDS*speed_v;