var gS = global.grid_spacing,
gD = global.grid_dimensions,
gX = obj_cursor.x,
gY = obj_cursor.y,
gOffsetX = gD[0] mod gS,
gOffsetY = gD[2] mod gS,
mosX = floor(gX/gS)*gS +gOffsetX,
mosY = floor(gY/gS)*gS +gOffsetY,
placed = false,
placeable = true;


if (input_check_released("action") || input_check_released("action")) && position_meeting(mosX,mosY,obj_grid) {
	dragging = false;
	placed = true;
} else if (input_check_pressed("action")) && !position_meeting(mosX,mosY,obj_grid) {
	if !placed { instance_destroy(); }
	//dragging = true;
	if position_meeting(gX,gY,obj_piece_slot) {
		with instance_position(gX,gY,obj_piece_slot) {
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
	x = gX;
	y = gY;
	gClampX = clamp(floor(x/gS),gD[0]/gS,gD[1]/gS)*gS;
	gClampY = clamp(floor(y/gS),gD[2]/gS,gD[3]/gS)*gS;
} else {
	x = gClampX;
	y = gClampY; 
}

if placed {
	// Check how script respects grid territories
	switch on_grid {
		case SAME:
			if (position_meeting(gClampX,gClampY,obj_territory_friendly) && team == "friendly") || (position_meeting(gClampX,gClampY,obj_territory_enemy) && team == "enemy") {
				placeable = true;
			} else { placeable = false; }
		break;
	
		case NEUTRAL:
			if !(position_meeting(gClampX,gClampY,obj_territory_enemy) && team == "friendly") && !(position_meeting(gClampX,gClampY,obj_territory_friendly) && team == "enemy") {
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
			if position_meeting(gClampX,gClampY,obj_generic_piece) {
				placeable = false;	
			}
		break;		
	}
}

if placed && placeable { 
	if instance_exists(obj_client) {	
		with obj_client {
			action[CREATE] = other.obj_piece;
			cX[0] = other.gClampX;
			cY[0] = other.gClampY;
		}
	} else {		
		if team == "friendly" { global.turns -= turn_cost; }
	
		if team == "enemy" { global.enemy_turns -= turn_cost; }
		
		if link != noone {
			//Switch depending on what type the slot is
			switch link.object_index {
				case obj_piece_slot:
					link.cooldown = 0;	
				break;
				case obj_power_slot:
					link.usable = false;	
				break;
			}
			
		}
		
		instance_create_layer(gClampX,gClampY,"Instances",object, {
			team: team,
			link: link,
			identity: identity,
			skip_move: true
		});		
	}
	instance_destroy();	 
} else if placed && place_immediately { 
	var avoidPlaying = false;
	if input_check_pressed("action") { 
		with instance_position(gClampX,gClampY,obj_generic_piece) {
			if team == global.team && hp > 0 {
				avoidPlaying = true;
			}
		}
	}
	if !avoidPlaying { select_sound(snd_put_down); }
	
	instance_destroy(); 
	exit;
}