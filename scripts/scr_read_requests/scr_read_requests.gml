function read_requests(ar,is_online = false) {
	var leng = array_length(ar);
	if leng <= 0 {
		exit;	
	}
	for (var i = 0; i < leng; i++) {
		var verified = array_shift(ar);
		execute_action(verified, is_online);
	}
	array_resize(ar,0);
}