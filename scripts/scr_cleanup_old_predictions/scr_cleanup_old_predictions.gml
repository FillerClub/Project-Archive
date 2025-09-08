// Clean up old predictions periodically
function cleanup_old_predictions() {
    var curTime = get_timer();
    var max_age = 5000000; // 5 seconds in microseconds
    var cleanup_keys = [];
    
    var pred_id = ds_map_find_first(prediction_history);
    while (pred_id != undefined) {
        var prediction_data = ds_map_find_value(prediction_history, pred_id);
        if (curTime - prediction_data.timestamp > max_age) {
            array_push(cleanup_keys, pred_id);
        }
        pred_id = ds_map_find_next(prediction_history, pred_id);
    }
    
    for (var i = 0; i < array_length(cleanup_keys); i++) {
        ds_map_delete(prediction_history, cleanup_keys[i]);
    }
    
    if (array_length(cleanup_keys) > 0) {
        show_debug_message("Cleaned up " + string(array_length(cleanup_keys)) + " old predictions");
    }
}