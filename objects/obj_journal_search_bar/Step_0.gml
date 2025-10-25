if mouse_pressed_on {
	is_active = true;
	keyboard_lastchar = "";
} else if input_check_pressed("action") {
	is_active = false;
	keyboard_lastchar = "";
}


if is_active {
    // Handle cursor blinking
    cursor_timer += delta_time*DELTA_TO_SECONDS;
    if (cursor_timer >= .3) {  // Blink every 30 frames (0.5 seconds at 60fps)
        cursor_visible = !cursor_visible;
        cursor_timer = 0;
    }
    
    // Get keyboard input
	var key = keyboard_lastchar;
	var strLeng = string_length(text);
	if (key != "") {
		if keyboard_check(vk_backspace) {
			if strLeng > 0 {
				text = string_copy(text, 1, strLeng - 1);
			}	
		} else {
			// Check if it's within max length
		    if strLeng < max_length {
				// Add the character to the text
		        text += key;
			}			
		}
		if instance_exists(send_text_to) {
			with send_text_to {
				text_input = other.text;
				update = true;
			}
		}
		keyboard_lastchar = "";  // Clear the last character
	}
}

mouse_pressed_on = false;