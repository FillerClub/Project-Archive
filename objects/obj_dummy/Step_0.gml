// Main Object Create Event
var cur = obj_cursor;
var mosX = cur.x;
var mosY = cur.y;
var gridX = cur.grid_pos[0];
var gridY = cur.grid_pos[1];

var placed = false;
var placeable = false;
var destroySelf = false;

piece_on_grid = cur.on_grid;
var gridRef = piece_on_grid;
if is_string(gridRef) {
	with obj_grid {
		if tag == gridRef {
			gridRef = id;
			break;
		}
	}
}
var z = instance_exists(gridRef) ? gridRef.z : 0;
if input_check_released("cancel") || input_mouse_check_released(mb_right) {
	instance_destroy();
	exit;
}
if input_check_released("action") && instance_exists(gridRef) { 
	dragging = false; 
	placed = true; 
} else if input_check_pressed("action") && !instance_exists(gridRef) {
	if !placed { 
		instance_destroy(); 
	} 
	//dragging = true; 
	if position_meeting(mosX,mosY,obj_piece_slot) { 
		with instance_position(mosX,mosY,obj_piece_slot) { 
			if identity == other.identity { 
				skip = true; select_sound(snd_put_down); } } } 
	else { select_sound(snd_put_down); }
}

// Dragging Movement
if (dragging) {
    x = mosX;
    y = mosY;
    if (gridRef != noone) {
        gClampX = gridX * GRIDSPACE + gridRef.x;
        gClampY = gridY * GRIDSPACE + gridRef.y;
    }
} else {
    x = gClampX;
    y = gClampY;
}


if !instance_exists(gridRef) {
	exit;	
}

// Placement Checks
placeable = grid_placement_valid(on_grid,gridRef.team,team);
var validPiece = piece_placement_valid(on_piece,gClampX,gClampY,team);
if validPiece != -1 {
	placeable = validPiece;
}
can_place = placeable;

if placed && (placeable || global.debug) {
    r_spawn_piece(identity, team, index, [gridX, gridY], gridRef.tag, type, link);
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
