if position_meeting(obj_cursor.x,obj_cursor.y,self) && input_check_pressed("action") {
	/*
	with obj_match_setting_switch {
		switch setting {
			case "Max Slots": global.max_slots = setting_value; break;
			case "Enable Bans": global.enable_bans = setting_value; break;
			case "Barrier Win Condition": global.barrier_criteria = setting_value; break;
			case "Time Until Timer Upgrade": global.timeruplength = setting_value; break;
			case "Max Pieces": global.max_pieces = setting_value; break;
		}	
	}
	*/	
	camera_set_view_pos(view_camera[0],0,0);
}
