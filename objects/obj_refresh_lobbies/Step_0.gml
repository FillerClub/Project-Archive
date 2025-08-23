if !(position_meeting(obj_cursor.x,obj_cursor.y,self) && input_check_pressed("action")) {
	exit;
}
steam_lobby_list_request();