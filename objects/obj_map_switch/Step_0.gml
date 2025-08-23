if obj_client_manager.member_status != MEMBERSTATUS.HOST || obj_ready.ready {
	exit;	
}
var curX = obj_cursor.x,
sendUpdate = false,
increment = 0;
if position_meeting(curX,obj_cursor.y,self) {
	if input_check_pressed("action") {
		sendUpdate = true;
		if curX < x +sprite_width/2 {
			increment = -1;	
		} else {
			increment = 1;
		}
		global.map = clamp(global.map +increment,1,MAP.MOVE);
	}
	if mouse_check_button_pressed(mb_middle) {
		sendUpdate = true;
		global.map = MAP.NORMAL;
	}
	if sendUpdate {
		steam_lobby_set_data("Map",global.map);
		//steam_relay_data({Message: SEND.MATCHDATA, Request: true, Data: {Map: map}});
	}
}
