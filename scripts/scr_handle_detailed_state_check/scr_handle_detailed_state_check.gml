function handle_detailed_state_check(host_detailed_state) {
    var local_detailed_state = capture_detailed_state();
    var differences = compare_detailed_states(local_detailed_state, host_detailed_state);
    
    if (array_length(differences.critical) > 0) {
        show_debug_message("Critical desync detected - requesting full resync");
        request_full_resync();
    } else if (array_length(differences.minor) > 0) {
        show_debug_message("Minor differences detected - applying corrections");
        apply_minor_corrections(differences.minor);
    } else {
        show_debug_message("Detailed states match");
    }
}