if global.pause {
	exit;	
}
var magicnum = 3000
var repet = delta_time*DELTA_TO_SECONDS*magicnum -frac(delta_time*DELTA_TO_SECONDS*magicnum) 
repeat repet {
	x += ((team == "friendly")?1:-1)*x_vel;
	y += y_vel;
	part_particles_burst(global.part_sys,x,y,part_bullet_trail);	
}

if falloff { dmg = dmg*.92; }