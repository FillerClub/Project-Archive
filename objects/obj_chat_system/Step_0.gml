// obj_chat_system - Step Event

input_blink_timer += delta_time / 1000000;

// Toggle chat with Enter key
if (keyboard_check_pressed(vk_enter)) {
    if (!chat_active) {
        // Open chat
        chat_active = true;
        keyboard_string = "";
    } else {
        // Send message
        if (string_length(chat_input) > 0) {
            send_message(chat_input);
            chat_input = "";
        }
        chat_active = false;
    }
}

// Handle chat input
if (chat_active) {
    chat_input = keyboard_string;

    // Limit length
    if (string_length(chat_input) > 100) {
        chat_input = string_copy(chat_input, 1, 100);
        keyboard_string = chat_input;
    }

    // Cancel with Escape
    if (keyboard_check_pressed(vk_escape)) {
        chat_active = false;
        chat_input = "";
        keyboard_string = "";
    }
}
