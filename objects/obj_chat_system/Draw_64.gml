// obj_chat_system - Draw GUI Event

if (!visible) exit;

draw_set_font(fnt_small);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Draw chat background
draw_set_color(c_black);
draw_set_alpha(0.7);
draw_rectangle(chat_x, chat_y, chat_x + chat_width, chat_y + chat_height, false);
draw_set_alpha(1);

// Draw messages
var msg_y = chat_y + chat_height - input_height - 10;
var visible_messages = min(8, array_length(chat_messages));

for (var i = array_length(chat_messages) - 1; i >= max(0, array_length(chat_messages) - visible_messages); i--) {
    var msg = chat_messages[i];

    // Draw sender name
    draw_set_color(c_yellow);
    var name_width = string_width(msg.sender_name + ": ");
    draw_text(chat_x + 5, msg_y, msg.sender_name + ":");

    // Draw message text
    draw_set_color(c_white);
    draw_text(chat_x + 5 + name_width, msg_y, msg.text);

    msg_y -= 20;
}

// Draw input box
draw_set_color(c_black);
draw_set_alpha(0.8);
draw_rectangle(chat_x, chat_y + chat_height - input_height,
              chat_x + chat_width, chat_y + chat_height, false);
draw_set_alpha(1);

// Draw input text
if (chat_active) {
    draw_set_color(c_lime);
    var cursor = (input_blink_timer mod 1.0 < 0.5) ? "|" : "";
    draw_text(chat_x + 5, chat_y + chat_height - input_height + 5,
             "> " + chat_input + cursor);
} else {
    draw_set_color(c_gray);
    draw_text(chat_x + 5, chat_y + chat_height - input_height + 5,
             "Press Enter to chat...");
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
