time_source_destroy(error_time);
var arLength = array_length(effects_management_array);
for (var i = 0; i < arLength; i++) {
	if time_source_exists(effects_management_array[i]) {
		time_source_destroy(effects_management_array[i]);
	}
}