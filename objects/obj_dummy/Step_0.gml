var cursorInstance = obj_cursor,
mosX = cursorInstance.x,
mosY = cursorInstance.y,
placed = false,
placeable = true;
piece_on_grid = obj_cursor.on_grid;


if instance_exists(piece_on_grid) {
	z = piece_on_grid.z
} else {
	z = 0;	
}

if input_check_released("action") && piece_on_grid != noone {
	dragging = false;
	placed = true;
} else if input_check_pressed("action") && piece_on_grid == noone {
	if !placed { instance_destroy(); }
	//dragging = true;
	if position_meeting(mosX,mosY,obj_piece_slot) {
		with instance_position(mosX,mosY,obj_piece_slot) {
			if identity == other.identity {
				skip = true;
				select_sound(snd_put_down);
			}
		}
	} else {
		select_sound(snd_put_down);
	}
}


if dragging {
	x = mosX;
	y = mosY;
	if piece_on_grid != noone {
		gClampX = cursorInstance.grid_pos[0]*GRIDSPACE +piece_on_grid.x;
		gClampY = cursorInstance.grid_pos[1]*GRIDSPACE +piece_on_grid.y;		
	}
} else {
	x = gClampX;
	y = gClampY; 
}

if placed {
	// Check how script respects grid territories
	switch on_grid {
		case SAME:
			if piece_on_grid.team == team {
				placeable = true;	
			} else { placeable = false; }
		break;
	
		case NEUTRAL:
			if piece_on_grid.team == team || piece_on_grid.team == "neutral" {
				placeable = true;	
			} else { placeable = false; }
		break;
	
		case PLACEABLENONE:
			placeable = false; 
		break; 
		
		default:
			placeable = true;
		break;
	}
	
	switch on_piece {
		case SAME:
			if position_meeting(gClampX,gClampY,obj_generic_piece) {
				var instattack = instance_position(gClampX,gClampY,obj_generic_piece);
				if instattack.team != team {
					placeable = false;
				} else { placeable = true; }
			}						
		break;
		
		case DIFFERENT:
			if position_meeting(gClampX,gClampY,obj_generic_piece) {
				var instattack = instance_position(gClampX,gClampY,obj_generic_piece);
				if instattack.team == team {
					placeable = false;	
				} else { placeable = true; }
			}
		break;
		
		case PLACEABLEANY:
			if position_meeting(gClampX,gClampY,obj_generic_piece) {
				placeable = true;
			}
		break;
	
		case PLACEABLENONE:
			if position_meeting(gClampX,gClampY,obj_obstacle) {
				placeable = false;	
			}
		break;		
	}
}
if global.debug { placeable = true; }
if placed && placeable { 		
	var ignoreCost = false;
	var abstractpositionforsomeungodlyreasonX = cursorInstance.grid_pos[0],
	abstractpositionforsomeungodlyreasonY = cursorInstance.grid_pos[1];
	r_spawn_piece(identity,team,[abstractpositionforsomeungodlyreasonX,abstractpositionforsomeungodlyreasonY],obj_cursor.on_grid.id);
	instance_destroy();	 
} else if placed && place_immediately { 
	var avoidPlaying = false;
	if input_check_pressed("action") { 
		with instance_position(gClampX,gClampY,obj_obstacle) {
			if team == global.player_team && total_health(hp) > 0 {
				avoidPlaying = true;
			}
		}
	}
	if !avoidPlaying { select_sound(snd_put_down); }
	instance_destroy(); 
	exit;
}