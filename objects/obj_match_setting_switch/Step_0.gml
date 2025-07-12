var curX = obj_cursor.x,
increment = 0;
if position_meeting(curX,obj_cursor.y,self) {
	if input_check_pressed("action") {
		if curX < x +sprite_width/2 {
			increment = -1;	
		} else {
			increment = 1;
		}
		setting_value += increment;
		// Clamp based on setting
		switch setting {
			case "Max Slots": setting_value = clamp(setting_value,1,12); break;
			case "Show Opponent's Picks": setting_value = clamp(setting_value,false,true); break;
			case "Barrier Win Condition": setting_value = clamp(setting_value,1,6); break;
			case "Time Until Timer Upgrade": setting_value = clamp(setting_value,1,120); break;
			case "Max Pieces": setting_value = clamp(setting_value,0,50); break;
		}
	}
	if mouse_check_button(mb_middle) {
		switch setting {
			case "Max Slots": setting_value = DEFAULT.MAXSLOTS; break;
			case "Show Opponent's Picks": setting_value = DEFAULT.SHOWSLOTS; break;
			case "Barrier Win Condition": setting_value = DEFAULT.BARRIER; break;
			case "Time Until Timer Upgrade": setting_value = DEFAULT.TIMELENGTH; break;
			case "Max Pieces": setting_value = infinity; break;
		}	
	}
}