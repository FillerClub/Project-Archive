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

function request_full_state_resync() {
    var request = {
        Message: SEND.REQUEST_RESYNC,
        client_id: obj_preasync_handler.steam_id,
        tick: current_tick
    };
    
    steam_relay_data(request);
    show_debug_message("Requested full state resync from host");
}