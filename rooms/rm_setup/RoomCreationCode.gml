randomize();
initialize_variables(true);


// Save Data
if file_exists(PROFILE) {
	var buff = buffer_load(PROFILE);
	buffer_seek(buff,buffer_seek_start,0);

	var strng = buffer_read(buff, buffer_string);
	buffer_delete(buff);
	
	load = json_parse(strng);
	global.name = load[0].name;
	global.master_volume = load[0].master_volume;
	global.sfx_volume = load[0].sfx_volume;
	global.music_volume = load[0].music_volume;
	global.cursor_sens = load[0].cursor_sens;
	global.fps_target = load[0].fps_target;
	global.screen_res = load[0].screen_res;
	global.fullscreen = load[0].fullscreen;
	global.difficulty = load[0].difficulty;
	global.first_boot = load[0].first_boot;
	global.tooltips_enabled = load[0].tooltips_enabled;
	global.healthbar_config = load[0].healthbar_config;
}
if file_exists(SAVEFILE) {
	var buff = buffer_load(SAVEFILE);
	buffer_seek(buff,buffer_seek_start,0);

	var strng = buffer_read(buff, buffer_string);
	buffer_delete(buff);
	
	load = json_parse(strng);
	global.level = load[0].level;
	global.tutorial_progress = load[0].tutorial_progress;
	global.unlocked_pieces = load[0].unlocked_pieces;
	global.unlocked_heroes = load[0].unlocked_heroes;
	global.loadout = load[0].loadout;
	global.active_hero = load[0].active_hero;
	global.discovered_pieces = load[0].discovered_pieces;
	
}

if !global.first_boot {
	game_boot(INSTANT);
} else {
	instance_create_layer(room_width/2,room_height/2,"Instances",obj_disclaimer_text);
}