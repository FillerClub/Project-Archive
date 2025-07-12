var found = false;
with obj_client_manager {
	// Check for opponent data
	for (var i = 0; i < array_length(players); i++) {
		if players[i].port == opponent_port {
			found = true;
			other.identity = players[i].hero;
			break;
		}
	}	
}
if !found {
	identity = "noone";	
}