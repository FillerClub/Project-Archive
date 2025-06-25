if running_matches <= 0 {
	match_index = 0;	
}
x = match_index*1280 -1280 +oX;
if keyboard_check(vk_escape) {
	exit_timer += delta_time*DELTA_TO_SECONDS;
} else {
	exit_timer = 0;
}	

if exit_timer >= 2 {
	game_end();	
}

if update_players {
	for (var d = 0; d < array_length(players); d++) {
		// Update player object, C for change
		var obj = players[d].object,
		nameC = false,
		heroC = false,
		loadoutC = false,
		statusC = false;
		with obj { 
			name = other.players[d].name;
			hero = other.players[d].hero;
			loadout = other.players[d].loadout;
			status = other.players[d].status;
		}
	}
}	