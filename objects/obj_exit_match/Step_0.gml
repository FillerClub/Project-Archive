if obj_ready.ready {
	exit;	
}
if position_meeting(obj_cursor.x,obj_cursor.y,self) && input_check_pressed("action") && global.game_state == RUNNING {
	if steam_lobby_get_lobby_id() != 0 {
		if steam_lobby_is_owner() {
			var transfered = false;
			for(var i = 0 ; i < steam_lobby_get_member_count() ; i++) {
				var userID = steam_lobby_get_member_id(i);
				if steam_lobby_get_owner_id() == userID {
					continue;
				}
				transfered = true;
				steam_lobby_set_owner_id(userID);
				break;
			}
			if !transfered {
				steam_lobby_set_type(steam_lobby_type_invisible);
				steam_lobby_set_joinable(false);		
			}
		}
		steam_lobby_leave();
		room_goto(rm_lobby);
	}
}