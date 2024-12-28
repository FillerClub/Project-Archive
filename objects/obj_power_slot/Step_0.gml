var create = false,
gS = GRIDSPACE,
selectthis = true,
gX = obj_cursor.x,
gY = obj_cursor.y,
mosX = floor(gX/gS)*gS,
mosY = floor(gY/gS)*gS;

if global.pause || skip || global.mode == "delete" || global.team != team {
	skip = false;
	exit;	
}

// On Click
if position_meeting(gX,gY,self) && input_check_pressed("action") {
	if usable && !instance_exists(obj_dummy) {
		select_sound(snd_pick_up);
		create = true;
	} 
}

create_piece_from_slot(create);