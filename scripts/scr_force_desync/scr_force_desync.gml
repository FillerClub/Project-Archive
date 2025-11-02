function force_desync() {
    show_debug_message("=== FORCING DESYNC FOR TESTING ===");
    // Randomly modify game state to cause desync
    var desync_type = irandom(3),
	verbose = global.verbose_debug;
    
    switch (desync_type) {
        case 0:
            // Modify piece HP
            with obj_obstacle {
                var rand = irandom(5);
				if rand < 2 {
					hurt(hp,random_range(-10, 10));
					if verbose {
						show_debug_message("Modified piece HP: " + string(tag));
					}
                    break;
                } else if rand > 3 {
					effect_generate(self,EFFECT.OVERHEALTH,"DEBUG_BUFF",10,10,noone,true)
					if verbose {
						show_debug_message("Modified piece HP: " + string(tag));
					}					
				}
            }
            break;
        
        case 1:
            // Modify resources
            global.friendly_turns += irandom_range(-5, 5);
            global.enemy_turns += irandom_range(-5, 5);
			if verbose {
				show_debug_message("Modified resources");
			}			
            break;
        
        case 2:
            // Move a piece slightly
            with obj_obstacle {
				grid_pos[0] += irandom_range(-2, 2);
				grid_pos[1] += irandom_range(-2, 2);
				if verbose {
					show_debug_message("Modified piece position: " + string(tag));
				}					    
            }
            break;
        
        case 3:
            // Delete a random piece
            with obj_obstacle {
                if irandom(5) == 0 {
					if verbose {
						show_debug_message("Deleted piece: " + string(tag));
					}
                    instance_destroy();
                    break;
                }
            }
            break;
    }
}