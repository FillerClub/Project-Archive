audio_stop_all();
initialize_variables();

var gS = global.grid_spacing;

switch room {
	case rm_world_one:
		deal_with_level(global.level);	
		enable_pausing = true;
	break;
	
	case rm_sandbox:
		deal_with_level([0,0])
		enable_pausing = true;
	break;
	
	case rm_setup:
		audio_group_unload(track1);
		audio_group_unload(track2);
		audio_group_unload(track3);
		audio_group_unload(track4);
		create_menu(FIRSTMENU,MAIN,room_width/2,100,64,75,15.2,fnt_basic,fa_center,fa_middle)
		enable_pausing = false;
	break;
	
	case rm_journal:
		/* 
		var name = object[NAME],
		obj = refer_database(name,OBJECT);
		instance_create_layer(576,256,"Instances",obj, {
			identity: name,
			team: global.team,
			place_sound: "nothing",
			display_mode: true,
			execute: "move"
		});
		*/
		global.mode = "move";
		create_menu(ONPIECEJOURNAL,PAUSE,192,128,32,20, 5,fnt_phone,fa_left,fa_middle);
		enable_pausing = true;
	break;
	
	default:
		enable_pausing = false;
	break;
}


