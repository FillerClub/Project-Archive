// Inherit the parent event
event_inherited();

prediction_history = ds_map_create(); // [tick] -> prediction_data
confirmed_tick = -1; // Last tick confirmed by host
prediction_sequence = 0;
save_state = -1;
cleanup_timer = 0;
verify_hash = -1;