function analyze_state_differences(local_state, host_state) {
    var critical_differences = [];
    var minor_differences = [];
    
    // Resource differences (critical if off by more than 1)
    var friendly_diff = abs(local_state.resources.friendly_turns - host_state.resources.friendly_turns);
    var enemy_diff = abs(local_state.resources.enemy_turns - host_state.resources.enemy_turns);
    var max_diff = abs(local_state.resources.max_turns - host_state.resources.max_turns);
    
    if (friendly_diff > 2 || enemy_diff > 2) {
        array_push(critical_differences, {
            type: "RESOURCES",
            local: local_state.resources,
            host: host_state.resources
        });
    } else if (friendly_diff > 0 || enemy_diff > 0) {
        array_push(minor_differences, {
            type: "RESOURCES",
            local: local_state.resources,
            host: host_state.resources
        });
    }
    
    // Piece differences
    var piece_diffs = compare_pieces(local_state.pieces, host_state.pieces);
    critical_differences = array_concat(critical_differences, piece_diffs.critical);
    minor_differences = array_concat(minor_differences, piece_diffs.minor);
    
    // Bullet differences (usually minor unless way off)
    var bullet_diffs = compare_bullets(local_state.bullets, host_state.bullets);
    minor_differences = array_concat(minor_differences, bullet_diffs.minor);
    critical_differences = array_concat(critical_differences, bullet_diffs.critical);
    
    return {critical: critical_differences, minor: minor_differences};
}
