function scale_grid(scale_factor, create_walls = true) {
    // Early exit if no scaling needed
    if (scale_factor == 1) exit;
    
    // Destroy walls if needed
    if create_walls {
        instance_destroy(obj_hero_wall);
    }
    
    var y_diff = 0;
    // Reposition units to midpoint

    // Scale grid objects
    with obj_grid {
        // Calculate center before scaling
        var center_y = (bbox_top + bbox_bottom) / 2;
        
        // Apply scale
        image_yscale = round(image_yscale*scale_factor);
        
        // Calculate new center after scaling and adjust position
        var new_center_y = (bbox_top + bbox_bottom) / 2;
        y += (center_y - new_center_y);
		// Store the difference for markers
        y_diff = oY - y;	
        // Trigger create event
		if create_walls {
			event_perform(ev_create, 0);
		}
	
    }
    
    // Scale and reposition markers
    with (obj_marker) {
        image_yscale *= scale_factor;
        y += y_diff;
    }
	with obj_obstacle {
		if object_index != obj_hero_wall && variable_instance_exists(self,"grid_pos") {
			grid_pos[1] += round(y_diff/GRIDSPACE);
		}
	}
}