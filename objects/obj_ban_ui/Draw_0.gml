// obj_ban_ui - Draw Event

if (!visible) exit;
if (!instance_exists(obj_phase_manager)) exit;

draw_set_font(fnt_medium);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

// Draw background
draw_set_color(c_black);
draw_set_alpha(0.9);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1);

// Draw title
draw_set_color(c_white);
draw_text(ui_x, 50, "BAN PHASE - Round " + string(obj_phase_manager.ban_round + 1) +
          "/" + string(obj_phase_manager.total_ban_rounds));

// Draw timer
var time_left = obj_phase_manager.get_time_remaining();
if (time_left >= 0) {
    draw_text(ui_x, 80, "Time: " + string(ceil(time_left)) + "s");
}

// Draw status
draw_set_font(fnt_small);
if (committed) {
    draw_set_color(c_lime);
    draw_text(ui_x - 200, 110, "You: COMMITTED");
} else {
    draw_set_color(c_yellow);
    draw_text(ui_x - 200, 110, "You: Selecting...");
}

if (opponent_committed) {
    draw_set_color(c_lime);
    draw_text(ui_x + 200, 110, "Opponent: COMMITTED");
} else {
    draw_set_color(c_gray);
    draw_text(ui_x + 200, 110, "Opponent: Selecting...");
}

// Draw piece grid
var grid_start_x = ui_x - (grid_cols * (cell_size + cell_padding)) / 2;
var grid_start_y = ui_y - (grid_rows * (cell_size + cell_padding)) / 2 + 50;

for (var i = 0; i < array_length(available_pieces); i++) {
    var piece_id = available_pieces[i];
    var col = i mod grid_cols;
    var row = floor(i / grid_cols);

    var cell_x = grid_start_x + col * (cell_size + cell_padding);
    var cell_y = grid_start_y + row * (cell_size + cell_padding);

    var is_banned = is_already_banned(piece_id);
    var is_selected = (piece_id == my_selection);

    // Draw cell
    if (is_banned) {
        draw_set_color(c_red);
        draw_set_alpha(0.7);
    } else if (is_selected && !committed) {
        draw_set_color(c_yellow);
        draw_set_alpha(0.8);
    } else {
        draw_set_color(c_gray);
        draw_set_alpha(0.3);
    }
    draw_rectangle(cell_x, cell_y, cell_x + cell_size, cell_y + cell_size, false);
    draw_set_alpha(1);

    // Draw piece name or sprite
    if (!is_banned) {
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        // Use piece name from EVERYTHING array
        if (piece_id < array_length(EVERYTHING)) {
            draw_text(cell_x + cell_size/2, cell_y + cell_size/2, EVERYTHING[piece_id]);
        }
    } else {
        // Draw X for banned
        draw_set_color(c_red);
        draw_line_width(cell_x + 10, cell_y + 10,
                       cell_x + cell_size - 10, cell_y + cell_size - 10, 3);
        draw_line_width(cell_x + cell_size - 10, cell_y + 10,
                       cell_x + 10, cell_y + cell_size - 10, 3);
    }
}

// Draw instructions
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
if (!committed) {
    draw_text(ui_x, room_height - 30, "Arrow Keys: Select | Z/Enter: Commit Ban");
} else {
    draw_text(ui_x, room_height - 30, "Waiting for opponent...");
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
