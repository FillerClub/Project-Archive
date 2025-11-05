function calculate_state_hash() {
    var hash_string = "";
    // Add player resources
    hash_string += string(global.friendly_turns) + "|";
    hash_string += string(global.enemy_turns) + "|";
    
	// Add all pieces in sorted order
    var pieces_data = [];
	var piece_info = "";
    with (obj_obstacle) {
        // Include critical, nonfloating point values
        piece_info = string(floor(total_health(hp)/2.5)) +"," +team +"," +string(tag);
		if variable_instance_exists(self,"identity") {
			piece_info += "," +string(identity);
		}
		if variable_instance_exists(self,"grid_pos") {
			piece_info += "," +string(grid_pos);
		}
		if variable_instance_exists(self,"piece_on_grid") {
			piece_info += "," +string(piece_on_grid);
		}			 
        array_push(pieces_data, piece_info);
    }
    
	// Sort for consistency
    array_sort(pieces_data, true);
    for (var i = 0; i < array_length(pieces_data); i++) {
        hash_string += pieces_data[i] + "|";
    }
   
    // Generate hash
    return md5_string_unicode(hash_string);
}