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
    if !player_has_resources(action.team,action.identity) {
        return {valid: false, reason: "insufficient_resources"};
    }
    /*
    if is_position_occupied(action.action_data.position) {
        return {valid: false, reason: "position_occupied"};
    }
	*/
    return {valid: true};
}

function validate_move(action) {
    var piece = find_tagged_piece(action.tag);
    if !instance_exists(piece) {
        return {valid: false, reason: "piece_not_found"};
    }
    /*
    if piece.team != get_team_from_player_id(player_id) {
        return {valid: false, reason: "not_your_piece"};
    }
    */
    return {valid: true};
}

function validate_delete(action) {
    return {valid: true};
}

function validate_interaction(action) {
    return {valid: true};
}