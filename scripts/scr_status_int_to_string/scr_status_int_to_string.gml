function status_int_to_string(status) {
	switch status {
		case ONLINESTATUS.IDLE:
		return "Idle";
		
		case ONLINESTATUS.INGAME:
		return "In a game";
		
		case ONLINESTATUS.WAITING:
		return "Waiting for opponent";
		
		case ONLINESTATUS.PREPARING:
		return "Preparing for a match";
		
		case ONLINESTATUS.SPECTATING:
		return "Spectacting a match";
	}
	// else 
	return "Loading...";
}