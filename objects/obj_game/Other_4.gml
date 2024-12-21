//audio_stop_all();
audio_group_stop_all(track1);
audio_group_stop_all(track2);
audio_group_stop_all(track3);
audio_group_stop_all(track4);
audio_group_stop_all(standalone_soundtracks);
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
		create_menu(FIRSTMENU,MAIN,room_width/2,100,64,75,15.2,fnt_basic,fa_center,fa_middle)
		enable_pausing = false;
	break;
	
	case rm_journal:
		var cont = JOURNAL;
		if typeof(journal_starting_entry) == "string" {
			journal_piece_create(journal_starting_entry);
			journal_starting_entry = noone;
			cont = POSTLEVELJOURNAL
		}	
		soundtrack_play(LOOKINGBACK);
		global.mode = "move";
		var 
		journalMenu = [],
		discoveredArray = global.discovered_pieces,
		discoveredArrayLength = array_length(discoveredArray);
		array_copy(journalMenu,0,discoveredArray,0,discoveredArrayLength);
		if cont == POSTLEVELJOURNAL {
			array_push(journalMenu,"Continue");
			discoveredArrayLength++;
		}
		array_copy(journalMenu,discoveredArrayLength,ONPIECEJOURNAL,0,array_length(ONPIECEJOURNAL));

		create_menu(journalMenu,cont,992,288,32,20, 10,fnt_phone,fa_left,fa_middle,true);
		enable_pausing = false;
	break;
	
	default:
		enable_pausing = false;
	break;
}


