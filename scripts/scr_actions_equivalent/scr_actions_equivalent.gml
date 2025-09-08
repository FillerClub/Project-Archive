function actions_equivalent(predicted, authoritative) {
    // Compare key fields
    if (predicted.action != authoritative.action) return false;
    
    switch (predicted.action) {
        case "Move":
            return (predicted.tag == authoritative.tag && 
                   predicted.grid_pos[0] == authoritative.grid_pos[0] &&
                   predicted.grid_pos[1] == authoritative.grid_pos[1] &&
                   predicted.piece_on_grid == authoritative.piece_on_grid);
                   
        case "Spawn":
            return (predicted.identity == authoritative.identity &&
                   predicted.team == authoritative.team &&
                   predicted.type == authoritative.type &&
                   predicted.grid_pos[0] == authoritative.grid_pos[0] &&
                   predicted.grid_pos[1] == authoritative.grid_pos[1] &&
                   predicted.piece_on_grid == authoritative.piece_on_grid);
                   
        case "Delete":
        case "Interact":
            return (predicted.tag == authoritative.tag);
    }
    
    return false;
}