// Main Object Create Event
var cur = obj_cursor;
var mosX = cur.x;
var mosY = cur.y;
var gridX = cur.grid_pos[0];
var gridY = cur.grid_pos[1];

var placed = false;
var placeable = true;
var destroySelf = false;

piece_on_grid = cur.on_grid;
var z = instance_exists(piece_on_grid) ? piece_on_grid.z : 0;

// Handle Input
// Release click — placing on existing grid
if (input_check_released("action") && piece_on_grid != noone) {
    dragging = false;
    placed = true;
}
// Press click — no piece under cursor
else if (input_check_pressed("action") && piece_on_grid == noone) {
    if (!placed) destroySelf = true;

    var slot_inst = instance_position(mosX, mosY, obj_piece_slot);
    if (slot_inst != noone && slot_inst.identity == identity) {
        skip = true;
        play_place_sound();
    } else {
        play_place_sound();
    }
}

// Dragging Movement
if (dragging) {
    x = mosX;
    y = mosY;
    if (piece_on_grid != noone) {
        gClampX = gridX * GRIDSPACE + piece_on_grid.x;
        gClampY = gridY * GRIDSPACE + piece_on_grid.y;
    }
} else {
    x = gClampX;
    y = gClampY;
}

// Placement Checks
if (placed) {
    if (!global.debug) {
        placeable = can_place_on_grid(piece_on_grid.team, team, on_grid);
        placeable = placeable && can_place_on_piece(gClampX, gClampY, team, on_piece);
    }
}

if (placed && placeable) {
    r_spawn_piece(identity, team, [gridX, gridY], piece_on_grid.id);
    destroySelf = true;
}
else if (placed && place_immediately) {
    var avoidPlaying = false;
    if (input_check_pressed("action")) {
        var obs = instance_position(gClampX, gClampY, obj_obstacle);
        if (obs != noone && obs.team == global.player_team && total_health(obs.hp) > 0) {
            avoidPlaying = true;
        }
    }
    if (!avoidPlaying) play_place_sound();
    destroySelf = true;
}

// Destroy
if (destroySelf) {
    instance_destroy();
    exit;
}
