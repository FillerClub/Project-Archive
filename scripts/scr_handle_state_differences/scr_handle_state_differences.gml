function handle_state_differences(differences) {
    switch (differences.type) {
        case "CRITICAL":
            show_debug_message("Critical desync detected - performing full resync");
            request_full_state_resync();
            break;
            
        case "MINOR":
            show_debug_message("Minor differences detected - applying corrections");
            apply_minor_corrections(differences.differences);
            break;
            
        case "SYNC":
            show_debug_message("States synchronized");
            break;
    }
}