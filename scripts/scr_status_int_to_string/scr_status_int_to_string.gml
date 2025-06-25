function status_int_to_string(status) {
	switch status {
		case ONLINESTATUS.IDLE:
		return "Idle";
		
		case ONLINESTATUS.INGAME:
		return "Playing a match";
		
		case ONLINESTATUS.OPENLOBBY:
		return "Hosting a match";
		
		case ONLINESTATUS.CLOSEDLOBBY:
		return "Preparing for a match";
		
		case ONLINESTATUS.SPECTATING:
		return "Spectacting a match";
	}
}