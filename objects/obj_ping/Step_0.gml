/*
if steam_lobby_get_lobby_id() == 0 {
	exit;
}
if ping_send {
	ping = current_time - ping_past_time;
	ping_send = false;	
	ping_past_time = current_time;
	steam_relay_data({Message: SEND.PING});
}