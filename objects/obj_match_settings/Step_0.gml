is_host = obj_client_manager.member_status == MEMBERSTATUS.HOST;
if position_meeting(obj_cursor.x,obj_cursor.y,self) && input_check_pressed("action") && is_host {
	room_goto(rm_match_settings);
}