function bullet_floor_die() {
	sound = snd_bullet_empty_slap;
	instance_destroy();	
}

function bullet_floor_stop() {
	x_vel = 0;
	y_vel = 0;
}