// obj_lobby_status_ui - Draw GUI Event

if (!instance_exists(obj_player_roster)) exit;
if (!instance_exists(obj_phase_manager)) exit;
if (!instance_exists(obj_lobby_controller)) exit;

draw_set_font(fnt_medium);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var line_height = 25;
var yy = ui_y;

// Draw phase
draw_set_color(c_white);
draw_text(ui_x, yy, "Phase: " + obj_phase_manager.get_phase_name());
yy += line_height;

// Draw phase timer if applicable
if (obj_phase_manager.phase_time_limit > 0) {
    var time_left = obj_phase_manager.phase_time_limit - obj_phase_manager.phase_timer;
    draw_text(ui_x, yy, "Time: " + string(ceil(time_left)) + "s");
    yy += line_height;
}

yy += 10;

// Draw players
draw_text(ui_x, yy, "PLAYERS:");
yy += line_height;

// Player 1
var p1 = obj_player_roster.player_slots[PLAYER_SLOT.PLAYER_1];
if (p1.is_occupied()) {
    var ready_indicator = p1.is_ready ? "[READY]" : "";
    draw_set_color(c_aqua);
    draw_text(ui_x + 20, yy, "P1: " + p1.display_name + " " + ready_indicator);
} else {
    draw_set_color(c_gray);
    draw_text(ui_x + 20, yy, "P1: [Waiting...]");
}
yy += line_height;

// Player 2
var p2 = obj_player_roster.player_slots[PLAYER_SLOT.PLAYER_2];
if (p2.is_occupied()) {
    var ready_indicator = p2.is_ready ? "[READY]" : "";
    draw_set_color(c_yellow);
    draw_text(ui_x + 20, yy, "P2: " + p2.display_name + " " + ready_indicator);
} else {
    draw_set_color(c_gray);
    draw_text(ui_x + 20, yy, "P2: [Waiting...]");
}
yy += line_height;

// Draw queue
if (array_length(obj_player_roster.player_queue) > 0) {
    yy += 10;
    draw_set_color(c_white);
    draw_text(ui_x, yy, "QUEUE:");
    yy += line_height;

    for (var i = 0; i < array_length(obj_player_roster.player_queue); i++) {
        var queued = obj_player_roster.player_queue[i];
        draw_set_color(c_ltgray);
        draw_text(ui_x + 20, yy, string(i + 1) + ". " + queued.display_name);
        yy += line_height;
    }
}

// Draw spectators
if (array_length(obj_player_roster.spectators) > 0) {
    yy += 10;
    draw_set_color(c_white);
    draw_text(ui_x, yy, "SPECTATORS:");
    yy += line_height;

    for (var i = 0; i < array_length(obj_player_roster.spectators); i++) {
        var spec = obj_player_roster.spectators[i];
        draw_set_color(c_ltgray);
        draw_text(ui_x + 20, yy, string(i + 1) + ". " + spec.display_name);
        yy += line_height;
    }
}

// Draw host indicator
yy += 10;
draw_set_color(c_lime);
if (obj_lobby_controller.is_host) {
    draw_text(ui_x, yy, "[You are HOST]");
} else {
    draw_text(ui_x, yy, "[Client]");
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
