if instance_exists(obj_ready) {
	if !obj_ready.ready && active {
		draw_self();	
	}
} else {
	draw_self();	
}
