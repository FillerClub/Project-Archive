if global.game_state == PAUSED {
	exit;	
}

// Handle requests
piece_handling();
process_requests(requests,online);