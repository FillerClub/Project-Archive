event_inherited();

if buffer_exists(save_state) {
	buffer_delete(save_state);	
}

ds_map_destroy(prediction_history);