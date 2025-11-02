function create_prediction(action) {
	// Generate prediction ID
    prediction_id_counter++;
    var pred_id = prediction_id_counter,
	verbose = global.verbose_debug;
    
    // Save state before prediction
    //var pre_state = create_save_state();
    // Execute action immediately (optimistic)
    array_push(obj_client_manager.requests,action);
	
    // Store prediction
    prediction_history[? pred_id] = {
        action: action,
        pre_state: -1,
		time_stamp: get_timer() -game_clock_start,//pre_state.time_stamp,
		verified: false,
    };
    // Send to host with prediction ID
    action.prediction_id = pred_id;
	if old_demented_prediction == -1 || pred_id < old_demented_prediction {
		old_demented_prediction = pred_id;	
	}	
	
	steam_relay_data(action);
    
	if verbose {
		show_debug_message("Executing " +string(action.Message) +" with prediction id " +string(pred_id));
	}
}