function capture_globals(save_globals_array) {
    var sendData = {};
	// Save global variables
    for (var i = 0, len = array_length(save_globals_array); i < len; i++) {
        var globalName = save_globals_array[i];
        if variable_global_exists(globalName) {
            struct_set(sendData, globalName, variable_global_get(globalName));
        }
    }
	return sendData;
}