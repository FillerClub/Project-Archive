#macro HEALTHCOSTMULTIPLIER .6
#macro TIMETOTAKE 1.5
#macro BLINKTIME .25
#macro EVERYTHING ["shooter","smoke_bomb","mortar","lobber","flyer","ball","splitter","double_shooter","short","accelerator","piercer","stick","shotgun","cross","bishop","wall","shield_gen","pawn","drum","bomber","super_stick","crawler","drooper","tank_crawler","jumper","super_tank_crawler","the_goliath","big_shooter","bomb"]
// TRANSITIONS
#macro INSTANT -1

// ONLINE
#macro D_IP "12.110.153.58"//"127.0.0.1"//"192.168.88.22"
#macro D_DEBUG_IP "127.0.0.1"//"192.168.88.22"
#macro D_CLIENT_PORT 9867
#macro D_SERVER_PORT 9868

enum SEND {
	DISCONNECT = 0,
	CONNECT = 1,
	MATCHDATA = 2,
	PLAYERJOIN = 3,
	GAMEDATA = 4,
	TOGGLEJOIN = 5,
	READY = 6,
	PING = 7,
}
#macro DATATYPES ["Status","Name","Hero","Loadout","MaxSlots","Bans","Barrier","TimeLength","MaxPieces","Map","Spawn","Move","Interact","Delete","Lose"]
#macro LOBBYDATA ["Status","Name","Player1","Player1Hero","Player1Loadout","Player1Ready","Player2","Player2Hero","Player2Loadout","Player2Ready","MaxSlots","Bans","Barrier","TimeLength","MaxPieces","Map"]
#macro SAVEOBJECTS [obj_obstacle,obj_piece_slot,obj_power_passive,obj_generic_hero,obj_generic_powerup,obj_grid,obj_bullet_parent,obj_battle_handler,obj_timer]
#macro SAVEOBJECTVARIABLES ["x","y","z","timer","move_cooldown_timer","hp","hp_max","grid_pos","cooldown","object_index","depth","team","effects_array","effects_timer","effects_management_array","invincible","dmg","x_vel","y_vel","y_spd_max","y_spd"]
#macro SAVEOBJECTIGNOREVARIABLES ["object_index"]
#macro SAVEGLOBALS ["max_turns","friendly_turns","enemy_turns"]
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
	HOST = 0,	
	MEMBER = 1,
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
