function replay_newer_predictions(rollback_prediction_id) {
    // Get timestamp of the rolled-back prediction
	var rollback_prediction = ds_map_find_value(obj_online_battle_handler.prediction_history, rollback_prediction_id);
    var rollback_time = rollback_prediction.timestamp;  // Get from prediction_data
    
    // Find all predictions that happened after this
    var newer_predictions = [];
    var pred_id = ds_map_find_first(obj_online_battle_handler.prediction_history);
    
    while (pred_id != undefined) {
        var prediction_data = ds_map_find_value(obj_online_battle_handler.prediction_history, pred_id);
        if (prediction_data.timestamp > rollback_time) {
            array_push(newer_predictions, prediction_data);
        }
        pred_id = ds_map_find_next(obj_online_battle_handler.prediction_history, pred_id);
    }
    
    // Sort by timestamp and re-execute
    array_sort(newer_predictions, function(a, b) {
        return a.timestamp - b.timestamp;
    });
    
    for (var i = 0; i < array_length(newer_predictions); i++) {
        array_push(requests,newer_predictions[i].action);
    }
    
    show_debug_message("Replayed " + string(array_length(newer_predictions)) + " newer predictions");
}
