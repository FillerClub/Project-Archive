function crawler_code() {
    // Early exit if not moving
    if (!moving) {
        timer -= timer_end;
        return;
    }
    
    // Calculate target position 
    var tM = tm_dp(1, team, toggle);
    var targetX = x + tM * GRIDSPACE + GRIDSPACE/2;
    var targetY = y + GRIDSPACE/2;
    
    // Check if target is on grid - if not, flip and recalculate
    if (!position_meeting(targetX, targetY, obj_grid)) {
        toggle = !toggle;
        tM = tm_dp(1, team, toggle);
        targetX = x + tM * GRIDSPACE + GRIDSPACE/2;
    }
    
    // Final grid check after potential flip, exit if can't move anywhere
    if (!position_meeting(targetX, targetY, obj_grid)) {
        timer -= timer_end;
        return;
    }
    
    // Get target grid
    var targetGrid = instance_position(targetX, targetY, obj_grid);
    
    // Check for obstacles
    var shouldMove = true;
    var shouldFlip = false;
    skip_timer = false;
    
    if (position_meeting(targetX, targetY, obj_obstacle)) {
        var obstacle = instance_position(targetX, targetY, obj_obstacle);
        
        with (obstacle) {
            if (total_health(hp) > 0 && object_index != obj_hero_wall) {
                // Living obstacle - wait
                other.skip_timer = true;
                shouldMove = false;
            } else if (total_health(hp) <= 0 && object_index == obj_hero_wall) {
                // Dead hero wall - destroy crawler
                instance_destroy(other);
                return;
            } else if (other.team == team) {
                // Same team obstacle - flip direction
                shouldFlip = true;
                shouldMove = false;
            } else {
                // Enemy obstacle - flip direction
                shouldFlip = true;
                shouldMove = false;
            }
        }
    }
    
    // Apply movement or direction change
    if (shouldFlip) {
        toggle = !toggle;
    } else if (shouldMove) {
        // Move to target position
        var targetGridPos = [
            floor((targetX - targetGrid.bbox_left) / GRIDSPACE),
            floor((targetY - targetGrid.bbox_top) / GRIDSPACE)
        ];
        
        piece_on_grid = targetGrid.tag;
        grid_pos = targetGridPos;
    }
	timer -= timer_end;
}