var cursorInstance = obj_cursor,
mosX = cursorInstance.x,
mosY = cursorInstance.y,
placed = false,
placeable = true;
cursor_on_grid = obj_cursor.on_grid;


if input_check_released("action") && cursor_on_grid != noone {
	dragging = false;
	placed = true;
} else if input_check_pressed("action") && cursor_on_grid == noone {
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
	if cursor_on_grid != noone {
		gClampX = cursorInstance.grid_pos[0]*GRIDSPACE +cursor_on_grid.x;
		gClampY = cursorInstance.grid_pos[1]*GRIDSPACE +cursor_on_grid.y;		
	}
} else {
	x = gClampX;
	y = gClampY; 
}

if placed {
	// Check how script respects grid territories
	switch on_grid {
		case SAME:
			if cursor_on_grid.team == team {
				placeable = true;	
			} else { placeable = false; }
		break;
	
		case NEUTRAL:
			if cursor_on_grid.team == team || cursor_on_grid.team == "neutral" {
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
			if position_meeting(gClampX,gClampY,obj_obstacle) {
				var instattack = instance_position(gClampX,gClampY,obj_obstacle);
				if instattack.team != team {
					placeable = false;
				} else { placeable = true; }
			}						
		break;
		
		case DIFFERENT:
			if position_meeting(gClampX,gClampY,obj_obstacle) {
				var instattack = instance_position(gClampX,gClampY,obj_obstacle);
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
	if instance_exists(obj_client) {	
		with obj_client {
			action[CREATE] = other.obj_piece;
			cX[0] = other.gClampX;
			cY[0] = other.gClampY;
		}
	} else {		
		var ignoreCost = false;
		// Don't immediately incur cost if necessary
		switch object {
			case obj_net_power:
				// Do nothing
			break;
			
			default:
				if team == "friendly" { global.player_turns -= turn_cost; }
				if team == "enemy" { global.opponent_turns -= turn_cost; }				
			break;
		}
		

		
		if link != noone {
			//Switch depending on what type the slot is
			switch link.object_index {
				case obj_piece_slot:
					link.cooldown = link.cooldown_length;	
				break;
				case obj_power_slot:
					link.cooldown = link.cooldown_length;	
				break;
			}
			
		}
		var gX = cursorInstance.grid_pos[0];
		var gY = cursorInstance.grid_pos[1];
		instance_create_layer(gClampX,gClampY,"Instances",object, {
			team: team,
			link: link,
			identity: identity,
			skip_move: true,
			grid_pos: [gX,gY],
			piece_on_grid: cursor_on_grid
		});		
		show_debug_message(on_grid);
		show_debug_message(on_piece);
	}
	instance_destroy();	 
} else if placed && place_immediately { 
	var avoidPlaying = false;
	if input_check_pressed("action") { 
		with instance_position(gClampX,gClampY,obj_obstacle) {
			if team == global.player_team && hp > 0 {
				avoidPlaying = true;
			}
		}
	}
	if !avoidPlaying { select_sound(snd_put_down); }
	
	instance_destroy(); 
	exit;
}