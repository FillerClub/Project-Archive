// Inherit the parent event
event_inherited();

save_state = -1;

// Prediction system
prediction_id_counter = 0;
prediction_history = ds_map_create();
prediction_cleanup_timer = 0;
old_demented_prediction = -1;