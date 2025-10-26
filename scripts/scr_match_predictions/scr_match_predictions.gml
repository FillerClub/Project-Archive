function match_predictions(predicted_action, host_action) {
    // Compare key fields to see if they match
    // Adjust based on your action structure
    
    if predicted_action.action_type != host_action.action_type {
        return false;
    }
    
    // Type-specific comparisons
    switch (predicted_action.action_type) {
        case "spawn":
            return predicted_action.tag == host_action.tag &&
                   predicted_action.grid_pos[0] == host_action.grid_pos[0] &&
                   predicted_action.grid_pos[1] == host_action.grid_pos[1] &&
				   predicted_action.piece_on_grid == host_action.piece_on_grid;
        
        case "move":
            return predicted_action.tag == host_action.tag &&
                   predicted_action.grid_pos[0] == host_action.grid_pos[0] &&
                   predicted_action.grid_pos[1] == host_action.grid_pos[1] &&
				   predicted_action.piece_on_grid == host_action.piece_on_grid;
    }
    return true;
}