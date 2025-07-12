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
		
		case "Master":
			textReturn = "Master Volume: " +string(round(global.master_volume*100));
		break;
		case "SFX":
			textReturn = "SFX Volume: " +string(round(global.sfx_volume*100));
		break;
		case "Music":
			textReturn = "Music Volume: " +string(round(global.music_volume*100));
		break;
		case "Cursor":
			textReturn = "Cursor Sensitivity: " +string(global.cursor_sens);
		break;
		case "Debug Mode":
			textReturn = "Debug: " +string(global.debug?"ON":"OFF");
		break;
		case "Set Name":
			textReturn = (global.name == "")?"Set Name":("Name: "+string(global.name));
		break;
		case "FPS":
			textReturn = "FPS: " +string(global.fps_target);
		break;
		case "Tooltips":
			textReturn = "Tooltips " +string(global.tooltips_enabled?"Enabled":"Disabled");
		break;
		case "Healthbars":
			switch global.healthbar_config {
				case HEALTHBARCONFIG.HIDEALL:
					textReturn = "Healthbars: Hide";
				break;
				case HEALTHBARCONFIG.ONHIT:
					textReturn = "Healthbars: On hit";
				break;
				case HEALTHBARCONFIG.SHOWALL:
					textReturn = "Healthbars: Show";
				break;
			}
		break;
		
		default:
			textReturn = text;	
		break;
	}
	return textReturn;
}