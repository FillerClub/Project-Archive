if global.pause {
	exit;	
}
var magicnum = 3000
var repet = delta_time*DELTA_TO_SECONDS*magicnum -frac(delta_time*DELTA_TO_SECONDS*magicnum) 
repeat repet {
	x += ((team == "friendly")?1:-1);
	part_particles_burst(global.part_sys,x,y,part_bullet_trail);	
}
