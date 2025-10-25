if room == target_room {
	seq_transition(global.load.entrance_transition);
	global.load = {};
	instance_destroy();	
}