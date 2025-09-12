function show_detailed_state_comparison() {
    var local_state = capture_detailed_state();
    var state_string = "=== LOCAL STATE ===\n";
    
    state_string += "Resources: F=" + string(local_state.resources.friendly_turns) + 
                   " E=" + string(local_state.resources.enemy_turns) + "\n";
    
    state_string += "Pieces (" + string(array_length(local_state.pieces)) + "):\n";
    for (var i = 0; i < min(5, array_length(local_state.pieces)); i++) {
        var piece = local_state.pieces[i];
        state_string += "  " + piece.tag + ": (" + string(piece.grid_pos[0]) + "," + 
                       string(piece.grid_pos[1]) + ") HP=" + string(piece.hp) + "\n";
    }
    
    state_string += "Bullets: " + string(array_length(local_state.bullets)) + "\n";
    state_string += "Heroes: " + string(array_length(local_state.heroes)) + "\n";
    
    show_debug_message(state_string);
}

function compare_states_verbose(local_state, host_state) {
    var differences = compare_states_detailed(local_state, host_state);
    
    if (array_length(differences.critical) > 0) {
        show_debug_message("=== CRITICAL DIFFERENCES ===");
        for (var i = 0; i < array_length(differences.critical); i++) {
            var diff = differences.critical[i];
            show_debug_message("CRITICAL: " + diff.type);
        }
    }
    
    if (array_length(differences.minor) > 0) {
        show_debug_message("=== MINOR DIFFERENCES ===");
        for (var i = 0; i < array_length(differences.minor); i++) {
            var diff = differences.minor[i];
            show_debug_message("MINOR: " + diff.type);
        }
    }
}