function scan_for_enemy(
    detect_walls = true, 
    limit = 100, 
    return_object = false, 
    zidth_scale = 1, 
    piece_x = x, 
    piece_y = y
) {
    var gS = GRIDSPACE;
    var tm = (team == "friendly") ? 1 : -1;
    var countLimit = 0;
    var x_scan = piece_x;

    repeat (limit) {
        // Step in scan direction
        x_scan += gS*tm;
        countLimit++;

        // Check for obstacle at this grid point
        var preScan = collision_point(x_scan, piece_y, obj_obstacle, false, true);

        // No object here → keep scanning
        if (preScan == noone) continue;

        // Z-axis check
        if (!z_collide(self, preScan, zidth_scale)) continue;

        // Process found object
        with (preScan) {
            // Ignore non-piece walls if detect_walls is false
            if (!detect_walls && object_get_parent(object_index) != obj_generic_piece) {
                continue; // Skip this and keep scanning
            }

            // Enemy detection
            if (team != other.team && !invincible && total_health(hp) > 0) {
                if (return_object) {
                    return id; // Return the found object
                } else {
                    return true;
                }
            }
        }

        // Stop if hit a boundary
        if (position_meeting(x_scan, piece_y, obj_boundary)) {
            break;
        }
    }

    // No enemy found
    return (return_object) ? noone : false;
}
