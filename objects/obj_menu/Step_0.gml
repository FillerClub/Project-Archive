var gX = obj_cursor.x,
gY = obj_cursor.y,
menI = menu_index,
inputed = false,
mouseOnButton = position_meeting(gX,gY,button_object);

if mouseOnButton || mouse_check_button_released(mb_left) {
	on_mouse = true;
} else if input_check_pressed(["right","left","down","up","action"]) {
	on_mouse = false;
}

if on_mouse {
	if mouseOnButton {
		var grabbedPurpose = -1;
		with instance_position(gX,gY,button_object) {	
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
	if input_check_released("action") && !on_mouse {
		inputed = true;
		var enteredPurpose = undefined;
		if current_index != -1 {
			enteredPurpose = menu[menI][current_index];	
		}
		
		menu_function(enteredPurpose,context);
		menI = menu_index;
	}
}

if current_index != prev_index {
	prev_index = current_index;
	switch context {
		case PAUSE:
		case JOURNAL:
		case POSTLEVELJOURNAL:
			audio_stop_sound(snd_phone_scroll);
			audio_play_sound(snd_phone_scroll,0,0);
		break;
		case MAIN:
			audio_stop_sound(snd_main_select);
			audio_play_sound(snd_main_select,0,0);	
		break;
		default:
		break;
	}
}

if input_check_released("action") && on_mouse && mouseOnButton && !inputed {
	var grabbedPurpose = "nothing";
	with instance_position(gX,gY,button_object) {
		grabbedPurpose = purpose;
	}
	menu_function(grabbedPurpose,context);
}

if !inputed && input_check_released("cancel_no_shift") {
	menu_function()
}