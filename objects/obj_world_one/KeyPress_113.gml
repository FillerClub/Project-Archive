if !global.debug {
	exit;	
}
with obj_generic_piece {
	if ai_controlled {
		instance_destroy();	
	}
}
timer = 0;
phase++;