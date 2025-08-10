enum DEFAULT {
	MAXSLOTS = 6,
	SHOWSLOTS = 1,
	BARRIER = 4,
	TIMELENGTH = 15,	
}
function default_game_rules() {
	global.max_slots = DEFAULT.MAXSLOTS;
	global.barrier_criteria = DEFAULT.BARRIER;
	global.show_opponent_slots = DEFAULT.SHOWSLOTS;
	global.max_pieces = infinity;
	global.timeruplength = DEFAULT.TIMELENGTH;
	global.player_team = "friendly";
	global.opponent_team = "enemy";
	global.max_turns = 6;
	global.friendly_turns = 4;
	global.enemy_turns = 4;
}