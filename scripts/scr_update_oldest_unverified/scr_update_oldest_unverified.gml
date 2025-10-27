function update_oldest_unverified() {
    oldest_unverified_prediction_id = -1;
    // Find smallest prediction_id that is unverified
    var pred_id = ds_map_find_first(prediction_history);
    while (pred_id != undefined) {
        var pred = prediction_history[? pred_id];
        if !pred.verified {
            if oldest_unverified_prediction_id == -1 || pred_id < oldest_unverified_prediction_id {
                oldest_unverified_prediction_id = pred_id;
            }
        }
        pred_id = ds_map_find_next(prediction_history, pred_id);
    }
}