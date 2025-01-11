function initialize_variables(isFresh = false){
	if isFresh {
		global.part_sys = part_system_create();
		global.timer_speed_mult = .5;
		global.name = "";
		global.othername = "";
		global.music_volume = .5;
		global.screen_res = [1280,720];
		global.fullscreen = false;
		global.level = [1,1];
		global.unlocked_pieces = ["shooter","wall","bishop","crawler","drooper","jumper","tank_crawler","super_tank_crawler","the_goliath","bomber"];
		global.loadout = ["shooter"];
		global.discovered_pieces = ["shooter","crawler"];
		global.unlocked_heroes = ["Warden"];	
		global.active_hero = "Warden";	
		global.debug = 0;
		global.max_slots = 5;
		global.max_pawns = 64;
		global.timer_max_speed_mult = 3.3;
		#macro GRIDSPACE 64
		global.cursor_sens = 3;
		global.fps_target = 60;
		global.tutorial_progress = 0;
		global.difficulty = 0;
	}
	
	
	global.max_turns = 5;
	global.max_barriers = 4;
	global.turns = 2;
	global.enemy_turns = 2;
	global.turn_increment = 1;
	global.mode = "move";
	global.pause = false;
	global.team = "friendly";
	global.enemy_team = "enemy";
	if array_length(global.unlocked_pieces) <= global.max_slots {
		global.loadout = global.unlocked_pieces;
	}
	timer[MAIN] = 0;
	timer[ALERT] = 0;
	timer[AI] = 0;
	timer_phase = 0;
	ai_pieces = [];
	friendly_pieces = [];
	ai_valid[PIECE] = [];
	ai_valid[MOVE] = [];
	lane_threat = [];
	lane_score = [];
	fresh = true;
	on_menu = false;
	on_pause_menu = false;
	tutorial_piece = noone;
}