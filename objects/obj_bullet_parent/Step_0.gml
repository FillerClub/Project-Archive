if global.game_state == PAUSED exit;	

var brk = false;
//Convert velocity to something useable
var baseBulletSpd = 1500,
realXVel = baseBulletSpd*x_vel*delta_time*DELTA_TO_SECONDS*global.level_speed,
realYVel = baseBulletSpd*y_vel*delta_time*DELTA_TO_SECONDS*global.level_speed;

// Calculate steps needed to take
var trailCover = clamp(ceil(distance_to_point(x +realXVel,y +realYVel)),1,32);
if instance_exists(target) {
	var zFinal = target.z;
	if object_get_parent(target.object_index) == obj_generic_piece {
		zFinal += target.piece_on_grid.z;
	}
	z_target = zFinal;
	x_target = target.x +GRIDSPACE/2;
	y_target = target.y +GRIDSPACE/2;
	if abs(y_init -y_target) > abs(x_init -x_target) {
		use_y_target = true;	
	} else {
		use_y_target = false;
	}
}
for (var trail = 0; trail < trailCover; trail++) {
	//Draw trail of bullet
	var trailX = lerp(x,x +realXVel,trail/trailCover),
	trailY = lerp(y,y +realYVel,trail/trailCover);
	bullet_lobbing(moving_z,x_target,y_target,z_target,x_init,y_init,z_init,lob_height,use_y_target);
	bullet_on_grid = collision_point(trailX,trailY,obj_grid,false,false);
	var bZOff = 0;
	if instance_exists(bullet_on_grid) {
		bZOff += bullet_on_grid.z;
	}
	if z < bZOff -32 {
		sound = snd_bullet_empty_slap;
		instance_destroy();	
		exit;
	} 
	/*
	var particle = -1;
	with obj_battle_handler {
		particle = bullet_part;
	}
	if particle != -1 {
		part_particles_create(global.part_sys,trailX,trailY -z,particle,1);
	}
	*/	
	var preCheckObj = collision_point(trailX,trailY,obj_obstacle,false,true);  
	if !instance_exists(preCheckObj) {
		continue;	
	}
	if !z_collide(self,preCheckObj) && preCheckObj != target.id {
		continue;
	}	
	if bullet_check_collision(trailX,trailY) { instance_destroy(); exit; }
}
var bZOff = 0;
depth = -10000 +bZOff +z;
if brk { exit; }
x += realXVel;
y += realYVel;

dmg = dmg/(max(distance_to_point(x_init,y_init)/falloff_dist,1));

