enum DEFAULT {
	MAXSLOTS = 6,
	SHOWSLOTS = 1,
	BARRIER = 4,
	TIMELENGTH = 30,	
}
function default_game_rules() {
	global.max_slots = DEFAULT.MAXSLOTS;
	global.barrier_criteria = DEFAULT.BARRIER;
	global.show_opponent_slots = DEFAULT.SHOWSLOTS;
	global.max_pieces = infinity;
	global.timeruplength = DEFAULT.TIMELENGTH;
	global.team = "friendly";
	global.enemy_team = "enemy";
	global.max_turns = 30;
	global.player_turns = 20;
	global.opponent_turns = 20;
}