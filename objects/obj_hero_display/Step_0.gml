//Wrap index
var endInd = array_length(unlocked_heroes) -1;
if index < 0 {
	index = endInd;	
}
if index > endInd {
	index = 0;	
}
if read && instance_exists(obj_client_manager) {
	var player1Hero = steam_lobby_get_data("Player1Hero"),
	player2Hero = steam_lobby_get_data("Player2Hero");
	if player == 1 {
		identity = player1Hero;	
		//show_message(string(player1Hero) +string(typeof(player1Hero)));
	}
	if player == 2 {
		identity = player2Hero;	
	}
	update_hero_display();
}	
if update {
	// Send update through server
	if instance_exists(obj_client_manager) {
		var player1 = steam_lobby_get_data("Player1"),
		player2 = steam_lobby_get_data("Player2");
		if other.player == 1 && player1 == obj_preasync_handler.steam_id {
			identity = unlocked_heroes[index];
			steam_bounce({Message: SEND.MATCHDATA, Player1Hero: identity});
			read = false;
		}
		if other.player == 2 && player2 == obj_preasync_handler.steam_id {
			identity = unlocked_heroes[index];
			steam_bounce({Message: SEND.MATCHDATA, Player2Hero: identity});
			read = false;
		}
	} else {
		identity = unlocked_heroes[index];
		global.active_hero = identity;
	}
	update_hero_display();
	update = false;
}
