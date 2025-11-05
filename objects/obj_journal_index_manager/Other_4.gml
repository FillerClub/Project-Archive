with obj_game {
	soundtrack_play(LOOKINGBACK);
	var 
	journalMenu = [],
	discoveredArray = global.discovered_pieces,
	discoveredArrayLength = array_length(discoveredArray);
	array_copy(journalMenu,0,discoveredArray,0,discoveredArrayLength);
	var leng = array_length(journalMenu);
	var listGenerate = [];
	for (var i = 0; i < leng; i++) {
		var pieceData = piece_database(journalMenu[i])
		var classString = "";
		switch pieceData.class {
			case DEFENSECLASS:
				classString = "defense defence";
			break;
			case OFFENSECLASS:
				classString = "offense offence";
			break;
			case CONTROLCLASS:
				classString = "control";
			break;
			case SUPPORTCLASS:
				classString = "support";
			break;
		}
		var keywordString = pieceData.name +" " +classString;
		if variable_struct_exists(pieceData,"keywords") {
			keywordString += " " +pieceData.keywords;	
		}
		listGenerate[i] = {
			code: journalMenu[i],
			name: pieceData.name,
			sprite: pieceData.journal_sprite,
			slot_sprite: pieceData.slot_sprite,
			class: pieceData.class,
			cost: pieceData.place_cost,
			hp: pieceData.hp,
			attack_power: pieceData.attack_power,
			slot_cooldown: pieceData.slot_cooldown,
			move_cooldown: pieceData.move_cooldown,
			moves: pieceData.moves,
			short_description: pieceData.short_description,
			full_description: pieceData.full_description,
			keywords: keywordString,
		}	
	}
	if typeof(journal_starting_entry) == "string" {
		// Start at appropriate journal index 
		for	(var j = 0; j < discoveredArrayLength; j++) {
			if discoveredArray[j] == journal_starting_entry {
				other.starting_index = j;
				obj_journal.index = j +1;
				journal_starting_entry = -1;
				break;	
			}
		}	
	} else {
		instance_destroy(obj_continue_from_journal);	
	}
	other.list = listGenerate;
	other.update = true;
	/*
	if cont == POSTLEVELJOURNAL {
		array_push(journalMenu,"Continue");
		discoveredArrayLength++;
	}
	array_copy(journalMenu,discoveredArrayLength,ONPIECEJOURNAL,0,array_length(ONPIECEJOURNAL));
	*/
	//create_menu(journalMenu,cont,992,138,32,20, 10,fnt_phone,fa_left,fa_middle,true);
}