function log_debug_prediction(message){
    if (!instance_exists(obj_debugger)) return;
    
    with (obj_debugger) {
        var timestamp = string(current_hour) + ":" + string(current_minute) + ":" + string(current_second);
        var entry = {
            text: "[" + timestamp + "] " +message,
        };
        
        array_push(prediction_log, entry);
        
        // Keep log size manageable
        if (array_length(prediction_log) > max_log_entries) {
            array_delete(prediction_log, 0, 1);
        }
    }
}