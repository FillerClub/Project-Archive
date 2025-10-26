function is_in_move_list(piece_inst, base_grid_pos, base_grid_tag, grid_pos, grid_tag) {
	// Find position to use as base
	var oGridBase = find_tagged_grid(base_grid_tag);
	if !instance_exists(oGridBase) {
		//show_debug_message("Grid not found");
		return -1;
	}
	//show_debug_message(string(base_grid_pos));
	var baseX =  oGridBase.bbox_left +base_grid_pos[0]*GRIDSPACE,
	baseY = oGridBase.bbox_top +base_grid_pos[1]*GRIDSPACE;
	
	var valid_moves = piece_inst.valid_moves,
	arrayLengthMovesList = array_length(valid_moves);
	// From each valid_moves array, grab each moves list (ONLY_ATTACK, ONLY_MOVE, BOTH)
	for (var list = 0; list < arrayLengthMovesList; list++) {
		// Filter out dead arrays
		if valid_moves[list] == undefined {
			//show_debug_message("Skipping this list");
			continue;	
		}
		var arrayLengthMoves = array_length(valid_moves[list]);
		for (var i = 0; i < arrayLengthMoves; i++) {
		    var precheckX = valid_moves[list][i][0];
		    var precheckY = valid_moves[list][i][1];
		    // Handle team & toggle string conversion
		    if is_string(precheckX) {
		        precheckX = tm_dp(real(precheckX), piece_inst.team, piece_inst.toggle);
		    }
		    if is_string(precheckY) {
		        precheckY = tm_dp(real(precheckY), piece_inst.team, piece_inst.toggle);
		    }
		    // Skip self-moves early
		    if precheckX == 0 && precheckY == 0 {
				//show_debug_message("Skipping redundant check");
		        continue;
		    }
		    // Calculate move position
		    var moveToX = baseX +(precheckX + 0.5)*GRIDSPACE;
		    var moveToY = baseY +(precheckY + 0.5)*GRIDSPACE;
		    var testGrid = instance_position(moveToX, moveToY, obj_grid);
		    if !instance_exists(testGrid) {
				//show_debug_message("Grid not found here");
		        continue;
		    }
			if testGrid.tag != grid_tag {
				//show_debug_message("Grid does not match move made");
				continue;
			}
			var gClampX =  floor((moveToX -testGrid.bbox_left)/GRIDSPACE),
			gClampY = floor((moveToY -testGrid.bbox_top)/GRIDSPACE);
			//show_debug_message(string(grid_pos) +" == " +string([gClampX,gClampY]));
			if grid_pos[0] == gClampX &&
			grid_pos[1] == gClampY {
				//show_debug_message("Successfully found move");
				return list;
			}
		}
	}	
	//show_debug_message("Move not found");
	return -1;
}