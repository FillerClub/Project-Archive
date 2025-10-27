function read_requests(ar,is_online = false) {
	var leng = array_length(ar);
	if leng <= 0 {
		exit;	
	}
	var verbose = global.verbose_debug;
	for (var i = 0; i < leng; i++) {
		var verified = array_shift(ar);
		if verbose {
			show_debug_message("Executing " +string(verified.action_type) +"... \n" +string(verified));
		}
		execute_action(verified, is_online);
	}
	array_resize(ar,0);
}