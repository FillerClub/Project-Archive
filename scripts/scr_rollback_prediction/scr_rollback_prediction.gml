function rollback_prediction(prediction, host_action) {
    var verbose = global.verbose_debug,
	timeStamp = prediction.pre_state.time_stamp;
	if verbose {
        show_debug_message("Restoring state from before prediction");
    }
    
    // Restore state before prediction
    load_save_state(prediction.pre_state,timeStamp);
    
    // Execute host's version if not rejected
    if host_action != noone && host_action.result == "success" {
        if verbose {
            show_debug_message("Applying host's corrected action");
        }
        array_push(other.requests,host_action);
    }
    
    // Re-execute any newer predictions
    replay_newer_predictions(timeStamp);
}