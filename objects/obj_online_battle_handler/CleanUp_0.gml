event_inherited();
ds_map_destroy(prediction_history);

if buffer_exists(save_state) {
	buffer_delete(save_state);	
}