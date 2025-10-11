function log_debug_state(message){
    if (!instance_exists(obj_debugger)) return;
    
    with (obj_debugger) {
        var timestamp = string(current_hour) + ":" + string(current_minute) + ":" + string(current_second);
        var entry = {
            text: "[" + timestamp + "] ",
            state: message
        };
        
        array_push(states_log, entry);
        
        // Keep log size manageable
        if (array_length(states_log) > max_log_entries) {
            array_delete(states_log, 0, 1);
        }
    }
}