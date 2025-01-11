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
	room_goto(rm_setup);
	save(SAVEFILE);
}