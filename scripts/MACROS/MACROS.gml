#macro HEALTHCOSTMULTIPLIER .6
#macro TIMETOTAKE 1.5
#macro BLINKTIME .25
#macro GRIDSPACE 64
#macro EVERYTHING ["shooter","small_shooter","smoke_bomb","mortar","lobber","flyer","ball","splitter","double_shooter","short","accelerator","piercer","stick","shotgun","cross","bishop","wall","shield_gen","pawn","drum","bomber","super_stick","crawler","drooper","tank_crawler","jumper","super_tank_crawler","the_goliath","big_shooter","bomb"]
// TRANSITIONS
#macro INSTANT -1
// GAME STATES
#macro RUNNING 0
#macro PAUSED 1
#macro TRANSITIONING 2
#macro LOADING 3
// ONLINE
#macro D_IP "12.110.153.58"//"127.0.0.1"//"192.168.88.22"
#macro D_DEBUG_IP "127.0.0.1"//"192.168.88.22"
#macro D_CLIENT_PORT 9867
#macro D_SERVER_PORT 9868
#macro TICKRATE 30 // Per second

// Phase timing constants (developer-controlled)
#macro PHASE_TIME_BANS_PER_ROUND 20      // 20 seconds per ban round
#macro PHASE_TIME_LOADOUTS 60            // 60 seconds for loadout selection
#macro PHASE_TIME_TRANSITION 3           // 3 seconds transition countdown
#macro READY_GRACE_PERIOD 1.5            // 1.5 seconds to unready after clicking

enum SEND {
	DISCONNECT = 0,
	CONNECT = 1,
	MATCHDATA = 2,
	PLAYERJOIN = 3,
	READY = 4,
	REQUESTTAG = 5,
	INSERTTAG = 6,
	PING = 7,

	// Lobby management
	PLAYER_JOIN = 8,
	PLAYER_LEAVE = 9,
	ROSTER_UPDATE = 10,
	JOIN_QUEUE = 11,
	LEAVE_QUEUE = 12,
	LOBBY_STATE = 13,

	// Settings
	SETTINGS_UPDATE = 14,

	// Phase management
	PHASE_CHANGE = 15,
	READY_TOGGLE = 16,

	// Ban phase
	BAN_COMMIT = 17,
	BAN_REVEAL = 18,
	BAN_NEXT_ROUND = 19,

	// Chat
	CHAT_MESSAGE = 20,

	// Game flow
	GAME_END = 21,

	// In-game
	GAMEDATA = 22,			// Client → Host: Action request
    TICK_RESULTS = 23,      // Host → Clients: Processed actions
    HASH_CHECK = 24,        // Host → Clients: State hash for verification/minor corrections
    REQUEST_FULL_RESYNC = 25,// Client → Host: Need full state
    FULL_RESYNC = 26		// Host → Client: Client processes save state
}
enum DEBUG {
	GAME,
	ONLINE,
	ONLINESTATESCOMPARE,
}

#macro DATATYPES ["Status","Name","Hero","Loadout","MaxSlots","Bans","Barrier","TimeLength","MaxPieces","Map","Spawn","Move","Interact","Delete","Lose"]
#macro LOBBYDATA ["Status","Name","Player1","Player1Hero","Player1Loadout","Player1Ready","Player2","Player2Hero","Player2Loadout","Player2Ready","MaxSlots","Bans","Barrier","TimeLength","MaxPieces","Map"]
#macro SAVEOBJECTS [obj_obstacle,obj_piece_slot,obj_power_passive,obj_generic_hero,obj_generic_powerup,obj_grid,obj_bullet_parent,obj_battle_handler,obj_timer]
#macro SAVEOBJECTVARIABLES ["tag","x","y","z","image_xscale","image_yscale","timer","move_cooldown_timer","hp","hp_max","piece_on_grid","grid_pos","cooldown","object_index","depth","team","effects_array","effects_timer","effects_management_array","invincible","dmg","x_vel","y_vel","y_spd_max","y_spd","starting_sequence_pos","starting_sequence","shooting","accel","resource_timer","identity"]
#macro SAVEOBJECTIGNOREVARIABLES ["object_index"]
#macro SAVEGLOBALS ["max_turns","friendly_turns","enemy_turns"]
#macro TIMESENSITIVEVARIABLES ["timer","move_cooldown_timer","cooldown","effects_timer","resource_timer"]

/*
enum DATA {
	//MATCHDATA
	STATUS = 0,
	NAME = 1,
	HERO = 2,
	LOADOUT = 3,
	MAXSLOTS = 4,
	SHOWSLOTS = 5,
	BARRIER = 6,
	TIMELENGTH = 7,
	MAXPIECES = 8,
	MAP = 9,
	//GAMEDATA
	SPAWN = 50,
	MOVE = 51,
	INTERACT = 52,
	DELETE = 53,
	LOSE = 54,
}
*/
enum MAP {
	NORMAL = 1,	
	SMALL = 2,	
	SPLIT = 3,	
	MOVE = 4,	
	HEIGHTS = 5,
}
enum ONLINESTATUS {
	IDLE = 0,
	WAITING = 1,
	PREPARING = 2,
	INGAME = 3,	
	SPECTATING = 4,
}
enum MEMBERSTATUS {
	SPECTATOR = -1,
	PLAYER1 = 0,
	PLAYER2 = 1,
}
enum PLAYER_SLOT {
	PLAYER_1 = 0,
	PLAYER_2 = 1,
	SPECTATOR = 2
}
enum LOBBY_PHASE {
	SETUP = 0,          // Waiting for players, hero selection, map settings
	BANS = 1,           // Simultaneous blind ban phase
	LOADOUTS = 2,       // Hidden loadout selection
	TRANSITION = 3,     // Show loadouts, countdown to game
	IN_GAME = 4         // Game is running
}
enum QUEUE_ROTATION {
	PLAYERS_STAY = 0,   // No rotation
	LOSERS_MOVE = 1,    // Loser goes to back of queue
	WINNERS_MOVE = 2,   // Winner goes to back of queue
	BOTH_MOVE = 3       // Both go to back, next 2 promoted
}
// Level
#macro SLOTROW 9
enum GROUNDTYPE {
	NORMAL = 0,
	WATER = 1,
}
enum DAMAGE {
	NORMAL = 0,
	PHYSICAL = 1,
	ENERGY = 2,
}
// PIECE FUNCTIONS
enum MEDIUM {
	GROUND = 0,
}
