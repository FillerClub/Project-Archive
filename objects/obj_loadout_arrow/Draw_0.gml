if instance_exists(obj_ready) {
	if !obj_ready.ready {
		draw_self();	
	}
} else {
	draw_self();	
}
