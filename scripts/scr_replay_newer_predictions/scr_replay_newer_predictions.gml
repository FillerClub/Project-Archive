function replay_newer_predictions(rollback_timestamp) {
    // Find all predictions that happened after the rolled-back one
    var predictions_to_replay = [];
    
    var pred_id = ds_map_find_first(prediction_history);
    while (pred_id != undefined) {
        var pred = prediction_history[? pred_id];
        if pred.pre_state.time_stamp > rollback_timestamp {
            array_push(predictions_to_replay, pred.action);
        }
        pred_id = ds_map_find_next(prediction_history, pred_id);
    }
    
    // Sort by timestamp
    array_sort(predictions_to_replay, function(a, b) {
        return a.time_stamp - b.time_stamp;
    });
    
    // Re-execute each prediction
    if array_length(predictions_to_replay) > 0 {
        if global.verbose_debug {
            show_debug_message("Re-executing " + string(array_length(predictions_to_replay)) + " newer predictions");
        }
        for (var i = 0; i < array_length(predictions_to_replay); i++) {
            array_push(other.requests,predictions_to_replay[i].action);
        }
    }
}