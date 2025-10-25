function generate_prediction_id() {
	static sequence = 0;
	return string(obj_preasync_handler.steam_id) + "_" + string(sequence++);
}