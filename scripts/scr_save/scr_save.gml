/// @function save(FILE);
/// @param {macro} file Which file to update values and save to
/// @description Saves to a file with everything the game needs to read (Read comments for further info)

//	[NOTE] In order to add new data to the save file do the following four steps:
//	1) Set a global variable in initialize_variables() script within obj_game
//	2) Within the rm_setup create event, within the save struct set the new variable to read from
//	3) Within this save() function, create the same variable to save to
//	4) Within the menu_function() script, edit the "Data" function to clear the global variable if needed
//	5) Delete the old save file on your system
function save(FILE) {
	switch FILE {
		case SAVEFILE:
			var progress = array_create(0);
			var saveP = {
				level: global.level,
				tutorial_progress: global.tutorial_progress,
				unlocked_pieces: global.unlocked_pieces,
				discovered_pieces: global.discovered_pieces,
				unlocked_heroes: global.unlocked_heroes,
				active_hero: global.active_hero,
				loadout: global.loadout,
			}
			array_push(progress,saveP);
			var strng = json_stringify(progress);
			var buff = buffer_create(string_byte_length(strng),buffer_grow,1);
			buffer_write(buff, buffer_string, strng);
			buffer_save(buff,SAVEFILE);
			buffer_delete(buff);			
		break;
		
		case PROFILE:
			var settings = array_create(0);
			var saveS = {
				name: global.name, 
				master_volume: global.master_volume,
				sfx_volume: global.sfx_volume,
				music_volume: global.music_volume,
				cursor_sens: global.cursor_sens,
				fps_target: global.fps_target,
				screen_res: global.screen_res,
				fullscreen: global.fullscreen,
				difficulty: global.difficulty,
				first_boot: global.first_boot,
			}
			array_push(settings,saveS);
			var strng = json_stringify(settings);
			var buff = buffer_create(string_byte_length(strng),buffer_grow,1);
			buffer_write(buff, buffer_string, strng);
			buffer_save(buff,PROFILE);
			buffer_delete(buff);			
		break;
	}
}
