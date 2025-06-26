function status_int_to_string(status) {
	switch status {
		case ONLINESTATUS.IDLE:
		return "Idle";
		
		case ONLINESTATUS.INGAME:
		return "Playing a match";
		
		case ONLINESTATUS.MATCHHOST:
		return "Hosting a match";
		
		case ONLINESTATUS.MATCHGUEST:
		return "Preparing for a match";
		
		case ONLINESTATUS.SPECTATING:
		return "Spectacting a match";
	}
	// else 
	return "Loading...";
}