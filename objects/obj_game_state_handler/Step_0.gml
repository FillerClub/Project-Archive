/*
// SAVE STATE (Enter key)
if keyboard_check_pressed(vk_enter) {
    try {

        create_system_message(["Game state saved"],TOP,false);
    } catch (error) {
        create_system_message(["Save failed: " + string(error.message)],TOP,false);
    }
}

// LOAD STATE (Backspace key)
if keyboard_check_pressed(vk_backspace) && buffer_exists(save_buffer) {
    try {
        load_save_state(stateData);
        create_system_message(["Game state loaded"],TOP,false);
    } catch (error) {
        create_system_message(["Load failed: " + string(error.message)],TOP,false);
    }
}

