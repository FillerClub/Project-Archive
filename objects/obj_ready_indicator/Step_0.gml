var userID = obj_preasync_handler.steam_id,
player1 = steam_lobby_get_data("Player1"),
player2 = steam_lobby_get_data("Player2"),
player1Ready = steam_lobby_get_data("Player1Ready"),
player2Ready = steam_lobby_get_data("Player2Ready");
if player1Ready != "" {
	player1Ready = bool(player1Ready);	
}
if player2Ready != "" {
	player2Ready = bool(player2Ready);	
}
if player == 1 && !is_string(player1Ready) {
	ready = player1Ready;
}
if player == 2 && !is_string(player2Ready) {
	ready = player2Ready;
}

image_index = ready;