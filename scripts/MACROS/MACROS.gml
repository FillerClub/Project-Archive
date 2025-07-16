#macro HEALTHCOSTMULTIPLIER .6
#macro TIMETOTAKE 1.5
#macro EVERYTHING ["shooter","splitter","double_shooter","short","accelerator","piercer","stick","shotgun","cross","bishop","wall","pawn","bomber","super_stick","crawler","drooper","tank_crawler","jumper","super_tank_crawler","the_goliath","big_shooter"]
// TRANSITIONS
#macro INSTANT -1

// ONLINE
#macro D_IP "10.25.131.212"//"127.0.0.1"//"192.168.88.22"
#macro D_PORT 45000
enum SEND {
	DISCONNECT = 0,
	CONNECT = 1,
	MATCHDATA = 2,
	GAMEDATA = 3,
	TOGGLEJOIN = 4,
	READY = 5,
	PING = 6,
}
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
	
	PORT = 244,
	MATCHPORT = 245,
	CREATEMATCH = 246,
	END = 255,
}
enum MAP {
	NORMAL = 1,	
	SMALL = 2,	
	SPLIT = 3,	
	MOVE = 4,	
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