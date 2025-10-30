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
enum SEND {
	DISCONNECT,
	CONNECT,
	MATCHDATA,
	PLAYERJOIN,
	READY,
	REQUESTTAG,
	INSERTTAG,
	PING,
	
	GAMEDATA,			// Client → Host: Action request
    TICK_RESULTS,       // Host → Clients: Processed actions
    HASH_CHECK,         // Host → Clients: State hash for verification
	STATE_CHECK,	// Host → Client: Send state for minor corrections
    FULL_RESYNC			// Host → Client: Client processes save state
}
enum DEBUG {
	GAME,
	ONLINE,
	ONLINESTATESCOMPARE,
}

#macro DATATYPES ["Status","Name","Hero","Loadout","MaxSlots","Bans","Barrier","TimeLength","MaxPieces","Map","Spawn","Move","Interact","Delete","Lose"]
#macro LOBBYDATA ["Status","Name","Player1","Player1Hero","Player1Loadout","Player1Ready","Player2","Player2Hero","Player2Loadout","Player2Ready","MaxSlots","Bans","Barrier","TimeLength","MaxPieces","Map"]
#macro SHORTSAVEOBJECTS [obj_piece_slot,obj_obstacle,obj_battle_handler,obj_timer,obj_generic_hero]
#macro SHORTSAVEOBJECTVARIABLES ["tag","x","y","z","object_index","depth","timer","move_cooldown_timer","hp","piece_on_grid","grid_pos","cooldown","accel","resource_timer"]
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
