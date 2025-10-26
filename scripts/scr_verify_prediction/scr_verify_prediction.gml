
function verify_prediction(host_action) {
    var pred_id = host_action.prediction_id,
    prediction = prediction_history[? pred_id],
	verbose = global.verbose_debug;
    
    if host_action.result == "success" {
        // Check if prediction matches
        if match_predictions(prediction.action, host_action) {
            // Prediction was correct!
            if verbose {
                show_debug_message("Prediction #" + string(pred_id) + " verified correct");
            }
        } else {
            // Prediction was wrong, need rollback
            if verbose {
                show_debug_message("Prediction #" + string(pred_id) + " MISMATCH - rolling back");
            }
            rollback_prediction(prediction, host_action);
        }
    } else {
        // Action was rejected
        if verbose {
            show_debug_message("Prediction #" + string(pred_id) + " REJECTED: " + host_action.rejection_reason);
        }
        rollback_prediction(prediction, noone);
    }
    // Clean up prediction
    ds_map_delete(prediction_history, pred_id);
}