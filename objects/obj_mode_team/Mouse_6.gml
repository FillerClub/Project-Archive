global.player_turns += 1;
global.opponent_turns += 1;
if (global.opponent_turns > global.max_turns) || (global.player_turns > global.max_turns) { 
	global.max_turns += 1;
}