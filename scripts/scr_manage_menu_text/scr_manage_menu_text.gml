function manage_menu_text(text){
	var textReturn = "Nothing";
	switch text {
		case "Campaign":
			textReturn = "Campaign: " + string(global.level[0]) + "-" + string(global.level[1]);
		break;
		
		case "Data":
			if global.debug {
				if obj_menu.savefile_exists || obj_menu.profile_exists {
					textReturn = "Clear ALL Save Data"
				} else {
					textReturn = "No Save Data";
				}
			} else {
				if obj_menu.savefile_exists {
					textReturn = "Clear Save Data"
				} else {
					textReturn = "No Save Data";
				}				
			}
		break;
		
		case "Music":
			textReturn = "Music Volume: " +string(global.music_volume*100);
		break;
		case "Cursor":
			textReturn = "Cursor Sensitivity: " +string(global.cursor_sens);
		break;
		
		case "Debug":
			textReturn = "Debug: " +string(global.debug?"ON":"OFF");
		break;
		
		case "FPS":
			textReturn = "FPS: " +string(global.fps_target);
		break;
		
		default:
			textReturn = text;	
		break;
	}
	return textReturn;
}