// obj_chat_system - Chat for lobby and in-game

depth = -500;  // Very front

// Chat messages
chat_messages = [];  // Array of {sender_name, message, timestamp}
max_messages = 50;

// Input
chat_input = "";
chat_active = false;
input_blink_timer = 0;

// UI
chat_x = 20;
chat_y = room_height - 250;
chat_width = 400;
chat_height = 200;
input_height = 30;

visible = true;

// Send chat message
function send_message(_text) {
    if (string_length(_text) == 0) return;

    var my_name = obj_preasync_handler.steam_name;

    // Add to my own chat
    add_message(my_name, _text);

    // Broadcast to all players
    steam_bounce({
        Message: SEND.CHAT_MESSAGE,
        sender_name: my_name,
        text: _text,
        timestamp: current_time
    });
}

// Receive chat message
function receive_message(_sender_name, _text, _timestamp) {
    // Don't add if it's from me (already added)
    if (_sender_name == obj_preasync_handler.steam_name) return;

    add_message(_sender_name, _text, _timestamp);
}

// Add message to chat log
function add_message(_sender_name, _text, _timestamp = current_time) {
    array_push(chat_messages, {
        sender_name: _sender_name,
        text: _text,
        timestamp: _timestamp
    });

    // Trim old messages
    if (array_length(chat_messages) > max_messages) {
        array_delete(chat_messages, 0, 1);
    }
}
