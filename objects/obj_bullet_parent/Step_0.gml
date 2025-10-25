if (global.game_state == PAUSED) exit;

// Base velocity
var baseBulletSpd = 1000;
var realXVel = baseBulletSpd * x_vel * delta_time * DELTA_TO_SECONDS * global.level_speed;
var realYVel = baseBulletSpd * y_vel * delta_time * DELTA_TO_SECONDS * global.level_speed;

// Final position
var finalX = x + realXVel;
var finalY = y + realYVel;

// Precompute distance and steps
var totalDist = distance_to_point(finalX, finalY);
var trailCover = clamp(ceil(totalDist), 1, 32);

// Target setup
if (instance_exists(target)) {
    z_target = target.z;
    if object_is_ancestor(target.object_index,obj_generic_piece) {
		if is_string(target.piece_on_grid) {
			with obj_grid {
				if tag == target.piece_on_grid {
					z_target += z;	
					break;
				}
			}	
		} else { z_target += target.piece_on_grid.z;}
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
var lastPixelX = undefined;
var lastPixelY = undefined;
var lastPixelZ = undefined;
// Trail loop
for (var trail = 0; trail < trailCover; trail++) {
	if moving_z {
		bullet_lobbing(x_target, y_target, z_target, x_init, y_init, z_init, lob_height, use_y_target);	
	}
    // Collision checks
    var hitGRID = collision_point(trailX, trailY, obj_grid, false, true),
    hitOBSTACLE = collision_point(trailX, trailY, obj_obstacle, false, true);
    // If it's an obstacle
   if instance_exists(hitOBSTACLE) {
		if z_collide(self, hitOBSTACLE) {
			if bullet_check_collision(trailX, trailY) {
				instance_destroy();
		        exit;
		    }
		}
    }
    var bZOff = 0;
    // If it's a grid object
    if instance_exists(hitGRID) {
        bZOff = hitGRID.z;
        if (z < bZOff - 32) {
            sound = snd_bullet_empty_slap;
            instance_destroy();
            exit;
        }
    }
	// Check if we've moved to a new pixel
    var currentPixelX = round(trailX);
    var currentPixelY = round(trailY);
    var currentPixelZ = round(z);
	
	if currentPixelX != lastPixelX || currentPixelY != lastPixelY || currentPixelZ != lastPixelZ {
		// Create particle in new pixel
		var bulletPart = -1;
		with obj_battle_handler {
			bulletPart = bullet_part;
		}
		if bulletPart != -1 {
			part_particles_create(global.part_sys,currentPixelX,currentPixelY -z,bulletPart,1);
		}
		lastPixelX = currentPixelX;
		lastPixelY = currentPixelY;		
		lastPixelZ = currentPixelZ;
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