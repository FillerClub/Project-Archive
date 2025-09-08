function generate_prediction_id() {
    if instance_exists(obj_preasync_handler) {
		prediction_sequence++;
		return string(obj_preasync_handler.steam_id) + "_" + string(prediction_sequence);
	}
}

function store_prediction(action,save_state_buffer) {
    var prediction_data = {
        action: action,
        state: create_save_state(save_state_buffer),
        timestamp: get_timer()
    };
    
    ds_map_set(prediction_history, action.prediction_id, prediction_data);
    show_debug_message("Stored prediction: " + action.prediction_id);
}