function game_boot(fade_out){
	var lD = {
		run: "MainMenu",
		rm: rm_main_menu,
		load: [standalone_soundtracks,sound_effects]
	}
	global.first_boot = false;
	start_transition(fade_out,sq_fade_in,lD);
	save(PROFILE);
}