/// @desc Generic piece code for movement
if !base_piece_behavior() || skip_move {
	skip_move = false;
	exit;	
}
if input_check_pressed("action") && !skip_click && execute == "move" && global.mode != "delete" {
	var arrayLengthMovesList = array_length(valid_moves);
	// From each valid_moves array, grab each moves list (ONLY_ATTACK, ONLY_MOVE, BOTH)
	for (var list = 0; list < arrayLengthMovesList; list++) {
		// Filter out dead arrays
		if valid_moves[list] == undefined || valid_moves[list] == 0 {
			continue;	
		}
		piece_attack(valid_moves[list],list,cost,false);
	}		
}

if global.game_state == RUNNING {
	skip_click = false;	
}