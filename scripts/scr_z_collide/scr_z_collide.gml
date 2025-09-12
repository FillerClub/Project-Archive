function z_collide(z_object_a, z_object_b, zidth_scale = 1) {
    // Validate instances
    if (!instance_exists(z_object_a) || !instance_exists(z_object_b)) {
        return false;
    }

    // Get z positions
    var zA = z_object_a.z;
    if variable_instance_exists(z_object_a, "piece_on_grid") { 
		if is_string(z_object_a.piece_on_grid) {
			with obj_grid {
				if tag == z_object_a.piece_on_grid {
					zA += z;	
				}
			}
		} else {
			if instance_exists(z_object_a.piece_on_grid) {
				zA += z_object_a.piece_on_grid.z;
			}
		}
    }

    var zB = z_object_b.z;
    if variable_instance_exists(z_object_b, "piece_on_grid") {
		if is_string(z_object_b.piece_on_grid) {
			with obj_grid {
				if tag == z_object_b.piece_on_grid {
					zB += z;	
				}
			}
		} else {
			if instance_exists(z_object_b.piece_on_grid) {
				zB += z_object_b.piece_on_grid.z;
			}
		}
    }

    // Collision check
    return !(
        zA + z_object_a.zidth * zidth_scale < zB - z_object_b.zidth ||
        zA - z_object_a.zidth * zidth_scale > zB + z_object_b.zidth
    );
}