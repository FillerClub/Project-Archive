var gX = obj_cursor.x,
gY = obj_cursor.y,
menI = menu_index,
inputed = false;

if input_mouse_moved() {
	if position_meeting(gX,gY,obj_button) {
		var grabbedPurpose = -1;
		with instance_position(gX,gY,obj_button) {	
			grabbedPurpose = purpose;
		}
		
		for (var i = 0; i < array_length(menu[menI]); i ++) {
			if grabbedPurpose == menu[menI][i] {
				current_index = i;	
			}
		}		
	}
} else {
	if (input_check_pressed("down")) {
		current_index = clamp(current_index +1,0,array_length(menu[menI]) -1);
	}
	if (input_check_pressed("up")) {
		current_index = clamp(current_index -1,0,array_length(menu[menI]) -1);	
	}
	if input_check_pressed("action") && !mouse_check_button(mb_left) {
		inputed = true
		var enteredPurpose = menu[menI][current_index];	
		menu_function(enteredPurpose,context);
		menI = menu_index;
	}
}
current_index = clamp(current_index,0,array_length(menu[menI]) -1);
if current_index != prev_index {
	prev_index = current_index;
	switch context {
		case PAUSE:
		case JOURNAL:
		case POSTLEVELJOURNAL:
			audio_stop_sound(snd_phone_scroll);
			audio_play_sound(snd_phone_scroll,0,0);
		break;
		default:
		break;
	}
}

if input_check_pressed("action") && input_source_using(INPUT_MOUSE) && position_meeting(gX,gY,obj_button) && !inputed {
	var grabbedPurpose = "nothing";
	with instance_position(gX,gY,obj_button) {
		grabbedPurpose = purpose;
	}
	menu_function(grabbedPurpose,context);
}

if !inputed && input_check_pressed("cancel") {
	menu_function()
}