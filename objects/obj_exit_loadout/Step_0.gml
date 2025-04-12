if position_meeting(obj_cursor.x,obj_cursor.y,self) && input_check_pressed("action") {
	if instance_exists(obj_hero_display) {
		global.active_hero = obj_hero_display.identity;
	}
	var arrayLength = instance_number(obj_loadout_slot);
	var array = array_create(arrayLength,0);
	with obj_loadout_slot {
		array[index] = identity;
	}
	global.loadout = array;
	save(SAVEFILE);
	var lD = {
		run: "MainMenu",
		rm: rm_main_menu,
		load: [standalone_soundtracks]
	}
	start_transition(sq_circle_out,sq_circle_in,lD);	
}