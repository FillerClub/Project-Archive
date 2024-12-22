#macro DELTA_TO_SECONDS 1/1000000
#macro DELTA_TO_FRAMES 1/6000
#macro SAVEFILE "save.td"
#macro PROFILE "profile.td"
#macro ALERT 1
#macro AI 2
randomize();
initialize_variables(true);
ai_seed = random(100);
// Save Data
if file_exists(PROFILE) {
	var buff = buffer_load(PROFILE);
	buffer_seek(buff,buffer_seek_start,0);

	var strng = buffer_read(buff, buffer_string);
	buffer_delete(buff);
	
	load = json_parse(strng);
	global.name = load[0].name;
	global.music_volume = load[0].music_volume;
	global.cursor_sens = load[0].cursor_sens;
	global.fps_target = load[0].fps_target;
	global.screen_res = load[0].screen_res;
	global.fullscreen = load[0].fullscreen;
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
	global.discovered_pieces = load[0].discovered_pieces;
	global.unlocked_heroes = load[0].unlocked_heroes;
}

// Set window
screen_resize(global.screen_res[0],global.screen_res[1],0);
window_set_fullscreen(global.fullscreen);
//Set FPS
game_set_speed(global.fps_target,gamespeed_fps);