function compare_states_detailed(host_hash, detailed_host_state) {
    var local_state = capture_detailed_state();
    var differences = analyze_state_differences(local_state, detailed_host_state);
    
    if (array_length(differences.critical) > 0) {
        return {type: "CRITICAL", differences: differences.critical};
    } else if (array_length(differences.minor) > 0) {
        return {type: "MINOR", differences: differences.minor};
    } else {
        return {type: "SYNC", differences: []};
    }
}
