if (global.game_state == PAUSED) exit;

// Base velocity
var baseBulletSpd = 1500;
var baseRate = delta_time * DELTA_TO_SECONDS * global.level_speed;
var realXVel = baseBulletSpd * x_vel * baseRate;
var realYVel = baseBulletSpd * y_vel * baseRate;
var ammoObj = noone;
explode_timer += baseRate;
image_angle += baseRate*rot_speed;
if explode_timer >= 8 {
	instance_destroy();
	exit;
}

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
			ammoObj.ammo--;
			audio_play_from_array([snd_lonestar_gunshot_1,snd_lonestar_gunshot_2,snd_lonestar_gunshot_3]);
			shot = true;
			instance_destroy();
		} else {
			with ammoObj {
				scr_error();
				audio_stop_sound(snd_critical_error);
				audio_play_sound(snd_critical_error,0,0);
			}
		}
	}
}
// Final position
var finalX = x + realXVel;
var finalY = y + realYVel;

// Precompute distance and steps
var totalDist = distance_to_point(finalX, finalY);
var trailCover = clamp(ceil(totalDist), 1, 32);

// Target setup
if (instance_exists(target)) {
    z_target = target.z;
    if (object_get_parent(target.object_index) == obj_generic_piece) {
        z_target += target.piece_on_grid.z;
    }
    x_target = target.x + GRIDSPACE / 2;
    y_target = target.y + GRIDSPACE / 2;
    use_y_target = (abs(y_init - y_target) > abs(x_init - x_target));
}

// Precompute increments for trail points
var stepX = (finalX - x) / trailCover;
var stepY = (finalY - y) / trailCover;
var trailX = x;
var trailY = y;

// Trail loop
for (var trail = 0; trail < trailCover; trail++) {
    bullet_lobbing(moving_z, x_target, y_target, z_target, x_init, y_init, z_init, lob_height, use_y_target);
    // Collision checks
    var hitGRID = collision_point(trailX, trailY, obj_grid, false, true);
    var bZOff = 0;
    // If it's a grid object
    if instance_exists(hitGRID) {
        bZOff = hitGRID.z;
    }
	if z < bZOff - 32 {
	    z = bZOff - 32;
		x_vel = 0;
		y_vel = 0;
		rot_speed = 0;
    }
    // Move to next trail point
    trailX += stepX;
    trailY += stepY;
}

// Depth
depth = -10000 + z;

// Apply final position
x = finalX;
y = finalY;

// Damage falloff
dmg /= max(totalDist / falloff_dist, 1);