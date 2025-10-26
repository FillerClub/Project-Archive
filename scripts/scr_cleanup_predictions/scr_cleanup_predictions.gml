function cleanup_stale_predictions() {
    var timeout = 9000000;  // 9 seconds in microseconds
    var stale_ids = [];
    
    var pred_id = ds_map_find_first(prediction_history);
    while (pred_id != undefined) {
        var pred = prediction_history[? pred_id];
		var timeElapsed = (get_timer() -game_clock_start) -pred.pre_state.time_stamp;
        if timeElapsed > timeout {
            array_push(stale_ids, pred_id);
            
            if global.verbose_debug {
                show_debug_message("Prediction #" + string(pred_id) + " timed out being " +string(timeElapsed/1000000) +" seconds old (network issue?)");
            }
            
            // Rollback stale prediction
            rollback_prediction(pred, noone);
        }
        
        pred_id = ds_map_find_next(prediction_history, pred_id);
    }
    
    // Delete stale predictions
    for (var i = 0; i < array_length(stale_ids); i++) {
        ds_map_delete(prediction_history, stale_ids[i]);
    }
}