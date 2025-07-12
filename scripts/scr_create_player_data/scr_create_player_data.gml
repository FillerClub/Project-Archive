function create_player_data(_ip, _port, _name, _status = ONLINESTATUS.IDLE, _hero = -1, _loadout = -1,_match_object = noone,_dummy_object = noone) constructor {
	ip = _ip;
	port = _port;
	name = _name;
	status = _status;
	hero = _hero;
	loadout = _loadout;
	match = _match_object;
	object = _dummy_object;
}