execute = true;
for (var i = 0; i < array_length(load); i++) {
	if !audio_group_is_loaded(load[i]) {
		execute = false;
	} 
}
if execute {
	switch run {
		case "Lvl":
			if file_exists(SAVEFILE) {
				var buff = buffer_load(SAVEFILE);
				buffer_seek(buff,buffer_seek_start,0);
				var strng = buffer_read(buff, buffer_string);
				buffer_delete(buff);

				load = json_parse(strng);
				global.level = load[0].level;
				with obj_game {
				//level = global.level;
				switch global.level[0] {
						case 1:
							switch global.level[1] {
								default:
									room_goto(rm_world_one);
								break;
							}
						break;
					}		
				}
			} else {
				save(SAVEFILE);
				room_goto(rm_world_one);
			}
		break;
		case "Sandbox":
				room_goto(rm_sandbox);
		break;
		case "Journal":
				room_goto(rm_journal);
		break;
		case "Loadout":
				room_goto(rm_loadout_zone);
		break;
	}
}
