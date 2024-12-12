global.turns += 1;
global.enemy_turns += 1;
if (global.enemy_turns > global.max_turns) || (global.turns > global.max_turns) { 
	global.max_turns += 1;
}