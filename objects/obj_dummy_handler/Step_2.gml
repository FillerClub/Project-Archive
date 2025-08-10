if global.game_state == PAUSED {
	exit;	
}

// Handle requests
process_requests(requests,online);

piece_handling();
