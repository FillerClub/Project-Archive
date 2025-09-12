function log_debug(message, color = c_white) {
    if (!instance_exists(obj_debugger)) return;
    
    with (obj_debugger) {
        var timestamp = string(current_hour) + ":" + string(current_minute) + ":" + string(current_second);
        var entry = {
            text: "[" + timestamp + "] " + message,
            color: color,
            time: get_timer()
        };
        
        array_push(debug_log, entry);
        
        // Keep log size manageable
        if (array_length(debug_log) > max_log_entries) {
            array_delete(debug_log, 0, 1);
        }
        
        // Also output to console
        show_debug_message(entry.text);
    }
}