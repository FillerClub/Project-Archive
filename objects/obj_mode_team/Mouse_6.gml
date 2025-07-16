global.friendly_turns += 1;
global.enemy_turns += 1;
if (global.enemy_turns > global.max_turns) || (global.friendly_turns > global.max_turns) { 
	global.max_turns += 1;
}