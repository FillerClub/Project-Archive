if !(position_meeting(obj_cursor.x,obj_cursor.y,self) && input_check_pressed("action")) {
	exit;
}
steam_lobby_create(steam_lobby_type_public,8);
steam_lobby_set_joinable(true);
room_goto(rm_match_menu);
default_game_rules();
