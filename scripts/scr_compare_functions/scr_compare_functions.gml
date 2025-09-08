function compare_pieces(local_pieces, host_pieces) {
    var critical = [];
    var minor = [];
    
    // Create lookup maps by tag
    var local_map = create_piece_map(local_pieces);
    var host_map = create_piece_map(host_pieces);
    
    // Check for missing/extra pieces (critical)
    var local_tags = ds_map_keys_to_array(local_map);
    var host_tags = ds_map_keys_to_array(host_map);
    
    for (var i = 0; i < array_length(local_tags); i++) {
        if (!ds_map_exists(host_map, local_tags[i])) {
            array_push(critical, {
                type: "EXTRA_PIECE",
                tag: local_tags[i],
                piece: ds_map_find_value(local_map, local_tags[i])
            });
        }
    }
    
    for (var i = 0; i < array_length(host_tags); i++) {
        if (!ds_map_exists(local_map, host_tags[i])) {
            array_push(critical, {
                type: "MISSING_PIECE", 
                tag: host_tags[i],
                piece: ds_map_find_value(host_map, host_tags[i])
            });
        }
    }
    
    // Compare existing pieces
    for (var i = 0; i < array_length(host_tags); i++) {
        var tag = host_tags[i];
        if (ds_map_exists(local_map, tag)) {
            var local_piece = ds_map_find_value(local_map, tag);
            var host_piece = ds_map_find_value(host_map, tag);
            
            // Grid position differences (critical)
            if (local_piece.grid_pos[0] != host_piece.grid_pos[0] || 
                local_piece.grid_pos[1] != host_piece.grid_pos[1]) {
                array_push(critical, {
                    type: "PIECE_GRID_POSITION",
                    tag: tag,
                    local: local_piece,
                    host: host_piece
                });
            }
            // Timer variance (minor if within tolerance)
            if (abs(local_piece.timer - host_piece.timer) > 1) {
                array_push(minor, {
                    type: "PIECE_PIXEL_POSITION",
                    tag: tag,
                    local: local_piece,
                    host: host_piece
                });
            } else if (abs(local_piece.timer - host_piece.timer) > 0) {
                array_push(minor, {
                    type: "PIECE_PIXEL_POSITION",
                    tag: tag,
                    local: local_piece,
                    host: host_piece
                });
            }
            
            // HP differences
            var hp_diff = abs(local_piece.hp -host_piece.hp);
            if (hp_diff > 1) {
                array_push(critical, {
                    type: "PIECE_HP_MAJOR",
                    tag: tag,
                    local: local_piece,
                    host: host_piece
                });
            } else if (hp_diff > 0) {
                array_push(minor, {
                    type: "PIECE_HP_MINOR",
                    tag: tag,
                    local: local_piece,
                    host: host_piece
                });
            }
        }
    }
    
    ds_map_destroy(local_map);
    ds_map_destroy(host_map);
    
    return {critical: critical, minor: minor};
}

function compare_bullets(local_bullets, host_bullets) {
    var critical = [];
    var minor = [];
    
    // Bullets are harder to match exactly, so use position-based matching
    var unmatched_local = variable_clone(local_bullets);
    var unmatched_host = variable_clone(host_bullets);
    
    // Find close matches
    for (var i = array_length(unmatched_local) - 1; i >= 0; i--) {
        var local_bullet = unmatched_local[i];
        
        for (var j = array_length(unmatched_host) - 1; j >= 0; j--) {
            var host_bullet = unmatched_host[j];
            
            var distance = point_distance(local_bullet.x, local_bullet.y, 
                                        host_bullet.x, host_bullet.y);
            
            if (distance < 64 && local_bullet.team == host_bullet.team) {
                // Close enough - check if needs correction
                if (distance > 8) {
                    array_push(minor, {
                        type: "BULLET_POSITION",
                        local: local_bullet,
                        host: host_bullet
                    });
                }
                
                // Remove from unmatched
                array_delete(unmatched_local, i, 1);
                array_delete(unmatched_host, j, 1);
                break;
            }
        }
    }
    
    // Remaining unmatched bullets (critical if many)
    if (array_length(unmatched_local) > 2 || array_length(unmatched_host) > 2) {
        array_push(critical, {
            type: "BULLET_COUNT_MISMATCH",
            extra_local: unmatched_local,
            missing_host: unmatched_host
        });
    }
    
    return {critical: critical, minor: minor};
}