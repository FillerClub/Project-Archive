function cleanup_verified_predictions() {
    // Only delete verified predictions that are older than oldest unverified
    if oldest_unverified_prediction_id == -1 {
        // All predictions verified - safe to delete all
        var to_delete = [];
        var pred_id = ds_map_find_first(prediction_history);
        while (pred_id != undefined) {
            array_push(to_delete, pred_id);
            pred_id = ds_map_find_next(prediction_history, pred_id);
        }
        for (var i = 0; i < array_length(to_delete); i++) {
            ds_map_delete(prediction_history, to_delete[i]);
        }
        if global.verbose_debug && array_length(to_delete) > 0 {
            show_debug_message("Cleaned up " + string(array_length(to_delete)) + " verified predictions");
        }
    } else {
        // Only delete verified predictions with ID < oldest_unverified_prediction_id
        var to_delete = [];
        var pred_id = ds_map_find_first(prediction_history);
        while (pred_id != undefined) {
            var pred = prediction_history[? pred_id];
            if pred.verified && pred_id < oldest_unverified_prediction_id {
                array_push(to_delete, pred_id);
            }
            pred_id = ds_map_find_next(prediction_history, pred_id);
        }
        for (var i = 0; i < array_length(to_delete); i++) {
            ds_map_delete(prediction_history, to_delete[i]);
        }
        if global.verbose_debug && array_length(to_delete) > 0 {
            show_debug_message("Cleaned up " + string(array_length(to_delete)) + " old verified predictions");
        }
    }
}