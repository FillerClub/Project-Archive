function validate_action(action) {
    // Route to specific validator
    switch (action.action_type) {
        case "Spawn":
            return validate_spawn(action);
     
        case "Move":
            return validate_move(action);
        
        case "Delete":
            return validate_delete(action);
        
        case "Interact":
            return validate_interaction(action);
        
        default:
            return {valid: false, reason: "unknown_action_type"};
    }
}

function validate_spawn(action) {   
    // Example checks - expand these
	var identity = action.identity;
    if !player_has_resources(action.team,identity) {
        return {valid: false, reason: "insufficient_resources"};
    }
    if !place_position_valid(identity,action.team,action.grid_pos,action.piece_on_grid,action.type) {
        return {valid: false, reason: "invalid_spot"};
    }
    return {valid: true};
}

function validate_move(action) {
    var piece = find_tagged_piece(action.tag);
    if !instance_exists(piece) {
        return {valid: false, reason: "piece_not_found"};
    }
	var listTypeValid = is_in_move_list(piece,action.o_grid_pos,action.o_piece_on_grid,action.grid_pos,action.piece_on_grid);
	if listTypeValid < 0 {
		return {valid: false, reason: "invalid_move"};		
	}
    return {valid: true};
}

function validate_delete(action) {
    return {valid: true};
}

function validate_interaction(action) {
    return {valid: true};
}