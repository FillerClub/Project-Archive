function compare_detailed_states(local_state, host_state) {
    var critical_differences = [];
    var minor_differences = [];
    
    // Check resources
    var friendly_diff = abs(local_state.resources.friendly_turns - host_state.resources.friendly_turns);
    var enemy_diff = abs(local_state.resources.enemy_turns - host_state.resources.enemy_turns);
    
    if (friendly_diff > 2 || enemy_diff > 2) {
        array_push(critical_differences, {
            type: "RESOURCES_CRITICAL",
            local: local_state.resources,
            host: host_state.resources
        });
    } else if (friendly_diff > 0 || enemy_diff > 0) {
        array_push(minor_differences, {
            type: "RESOURCES_MINOR",
            local: local_state.resources,
            host: host_state.resources
        });
    }
    
    // Check pieces
    var piece_diffs = compare_pieces_detailed(local_state.pieces, host_state.pieces);
    critical_differences = array_concat(critical_differences, piece_diffs.critical);
    minor_differences = array_concat(minor_differences, piece_diffs.minor);
    
    // Check bullets (usually minor unless count way off)
    var bullet_count_diff = abs(array_length(local_state.bullets) - array_length(host_state.bullets));
    if (bullet_count_diff > 3) {
        array_push(critical_differences, {
            type: "BULLET_COUNT_CRITICAL",
            local_count: array_length(local_state.bullets),
            host_count: array_length(host_state.bullets)
        });
    } else if (bullet_count_diff > 0) {
        array_push(minor_differences, {
            type: "BULLET_COUNT_MINOR", 
            local_count: array_length(local_state.bullets),
            host_count: array_length(host_state.bullets)
        });
    }
    
    return {
        critical: critical_differences,
        minor: minor_differences
    };
}

function compare_pieces_detailed(local_pieces, host_pieces) {
    var critical = [];
    var minor = [];
    
    var local_map = create_lookup_map(local_pieces);
    var host_map = create_lookup_map(host_pieces);
    
    var local_tags = ds_map_keys_to_array(local_map);
    var host_tags = ds_map_keys_to_array(host_map);
    
    // Check for missing/extra pieces (critical)
    for (var i = 0; i < array_length(local_tags); i++) {
        if (!ds_map_exists(host_map, local_tags[i])) {
            array_push(critical, {
                type: "EXTRA_PIECE",
                tag: local_tags[i]
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
                    type: "PIECE_POSITION_CRITICAL",
                    tag: tag,
                    local: local_piece,
                    host: host_piece
                });
            }
            // Timer differences (minor)
            if (abs(local_piece.timer - host_piece.timer) > 1) {
                array_push(minor, {
                    type: "PIECE_TIMER_MINOR",
                    tag: tag,
                    local: local_piece,
                    host: host_piece
                });
            }
            // Z differences (minor)
            if (abs(local_piece.z - host_piece.z) > 32) {
                array_push(minor, {
                    type: "PIECE_Z_MINOR",
                    tag: tag,
                    local: local_piece,
                    host: host_piece
                });
            }
            
            // HP differences
            var hp_diff = abs(local_piece.hp - host_piece.hp);
            if (hp_diff > 2.5) {
                array_push(critical, {
                    type: "PIECE_HP_CRITICAL",
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