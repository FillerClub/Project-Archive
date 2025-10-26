function grid_placement_valid(behavior,grid_team,place_team) {
	switch behavior { 
		case SAME: 
			if grid_team == place_team { return true; } 
			else { return false; } 
			
		case NEUTRAL: 
			if grid_team == place_team || grid_team == "neutral" { return true; } 
			else { return false; }
			
		case PLACEABLENONE: return false; 
		
		default: return true; 
	} 
}
function piece_placement_valid(behavior,place_x,place_y,place_team) {
	switch behavior { 
		case SAME: 
			if position_meeting(place_x,place_y,obj_generic_piece) { var instattack = instance_position(place_x,place_y,obj_generic_piece); 
				if instattack.team != place_team { return false; } 
				else { return true; } } 
		return -1;
		
		case DIFFERENT: if position_meeting(place_x,place_y,obj_generic_piece) { var instattack = instance_position(place_x,place_y,obj_generic_piece); 
			if instattack.team == place_team { return false; } 
			else { return true; } }
		return -1;
		
		case PLACEABLEANY: 
			if position_meeting(place_x,place_y,obj_generic_piece) { return true; } 
		return -1;
		
		case PLACEABLENONE: 
			if position_meeting(place_x,place_y,obj_obstacle) { return false; } 
		return -1;
		
		default: return -1;
	}
}