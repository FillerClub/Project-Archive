execute = true;
for (var i = 0; i < array_length(load); i++) {
	if !audio_group_is_loaded(load[i]) {
		execute = false;
	} 
}
if execute {
	finish_loading(run,rm);
}
