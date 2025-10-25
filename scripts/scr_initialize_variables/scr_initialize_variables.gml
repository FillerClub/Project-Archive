function initialize_variables(isFresh = false) {
	if isFresh {
		// Game Rules
		global.player_team = "friendly";
		global.opponent_team = "enemy";
		global.barrier_criteria = 4;
		global.max_turns = 6;
		global.timeruplength = DEFAULT.TIMELENGTH;
		global.timer_max_speed_mult = 4;
		global.friendly_turns = 4;
		global.enemy_turns = 4;
		global.turn_increment = 1;	
		global.max_slots = 6;
		global.max_pieces = infinity;
		global.game_state = LOADING;
		global.part_sys = part_system_create();
		global.timer_speed_mult = .5;
		global.opponent_hero = "nothing";
		global.opponent_loadout = ["Empty"];
		global.save_state = "";
		global.max_ai_moving_pieces = infinity;
		global.verbose_debug = false;
		enum HEALTHBARCONFIG {
			HIDEALL = 0,
			ONHIT = 1,
			SHOWALL = 2,
		}
	}
	
	global.level_speed = 1;		
	global.mode = "move";
	global.load = {
		run: "MainMenu",
		rm: rm_main_menu,
		load: [standalone_soundtracks,sound_effects]
	};
	


	if array_length(global.unlocked_pieces) <= global.max_slots {
		global.loadout = global.unlocked_pieces;
	}
	fresh = true;
	on_menu = false;
	on_pause_menu = false;
}