function apply_minor_corrections(minor_differences) {
    show_debug_message("Applying " + string(array_length(minor_differences)) + " minor corrections");
    
    for (var i = 0; i < array_length(minor_differences); i++) {
        var diff = minor_differences[i];
        
        switch (diff.type) {
            case "RESOURCES_MINOR":
                global.friendly_turns = diff.host.friendly_turns;
                global.enemy_turns = diff.host.enemy_turns;
                show_debug_message("Corrected resource values");
                break;
                
            case "PIECE_TIMER_MINOR":
                with (obj_generic_piece) {
                    if (tag == diff.tag) {
						timer = diff.host.timer;
                        break;
                    }
                }
                break;
				
            case "PIECE_Z_MINOR":
                with (obj_generic_piece) {
                    if (tag == diff.tag) {
						z = diff.host.z;
                        break;
                    }
                }
                break;
                
            case "PIECE_HP_MINOR":
                with (obj_generic_piece) {
                    if (tag == diff.tag) {
                        hp = diff.host.hp;
                        break;
                    }
                }
                break;
                
            case "BULLET_COUNT_MINOR":
                show_debug_message("Minor bullet count difference - will self-correct");
                break;
        }
    }
}
