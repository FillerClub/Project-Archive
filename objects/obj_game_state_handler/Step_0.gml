// SAVE STATE (Enter key)
if keyboard_check_pressed(vk_enter) {
    try {
		create_save_state(save_buffer);	
        create_system_message(["Game state saved"],TOP,false);
    } catch (error) {
        create_system_message(["Save failed: " + string(error.message)],TOP,false);
    }
}

// LOAD STATE (Backspace key)
if keyboard_check_pressed(vk_backspace) {
    try {
        load_save_state(save_buffer);
        create_system_message(["Game state loaded"],TOP,false);
    } catch (error) {
        create_system_message(["Load failed: " + string(error.message)],TOP,false);
    }
}

