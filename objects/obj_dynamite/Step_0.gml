if global.game_state == PAUSED exit;	

var brk = false;
//Convert velocity to something useable
var baseBulletSpd = 1500,
realXVel = baseBulletSpd*x_vel*delta_time*DELTA_TO_SECONDS*global.level_speed,
realYVel = baseBulletSpd*y_vel*delta_time*DELTA_TO_SECONDS*global.level_speed,
timerSpd = delta_time*DELTA_TO_SECONDS*global.level_speed;
image_angle += timerSpd*rot_speed;
explode_timer += timerSpd;
if explode_timer >= 8 {
	instance_destroy();
	exit;
}
var ammoObj = noone;
if instance_exists(obj_constant_reload) {
	with obj_constant_reload {
		if team == other.team {
			ammoObj = id;	
		}
	}
}
if instance_exists(ammoObj) {
	if collision_rectangle(x -hitbox,y -hitbox -z,x +hitbox,y +hitbox -z,obj_cursor,false,true) && input_check_pressed("action") {
		if ammoObj.ammo > 0 {
			instance_destroy();
			ammoObj.ammo--;
			audio_play_sound(snd_final_bullet,0,0);
			shot = true;
		} else {
			with ammoObj {
				scr_error();
				audio_stop_sound(snd_critical_error);
				audio_play_sound(snd_critical_error,0,0);
			}
		}
	}
}
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
	bullet_on_grid = collision_point(x,y,obj_grid,false,false);
	var bZOff = 0;
	if instance_exists(bullet_on_grid) {
		bZOff += bullet_on_grid.z;
	}
	if z < bZOff -32 {
		x_vel = 0;
		y_vel = 0;
		z = bZOff -32;
		rot_speed = 0;
		instance_destroy(target);
	}
}
var bZOff = 0;
depth = -10000 +bZOff +z;
if brk { exit; }
x += realXVel;
y += realYVel;

dmg = dmg/(max(distance_to_point(x_init,y_init)/falloff_dist,1));

