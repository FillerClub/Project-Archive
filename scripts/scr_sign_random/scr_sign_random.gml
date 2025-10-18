function sign_random(input = undefined) {
	if !is_numeric(input) {
		return irandom(1)*2 -1;	
	} else {
		return input*(irandom(1)*2 -1);	
	}
}