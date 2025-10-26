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
		var saveStateRead = save_buffer,
		timeStamp = 0;
		if buffer_exists(saveStateRead) {
			show_debug_message("Getting save state timestamp");
			buffer_seek(saveStateRead,buffer_seek_start,0);
			saveStateRead = json_parse(buffer_read(saveStateRead,buffer_string));
			timeStamp = saveStateRead.time_stamp;
		}
        load_save_state(saveStateRead,timeStamp);
        create_system_message(["Game state loaded"],TOP,false);
    } catch (error) {
        create_system_message(["Load failed: " + string(error.message)],TOP,false);
    }
}

