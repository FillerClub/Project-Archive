/// @desc Generic piece code for movement
if piece() && !skip_move {
	switch execute {
		case "move":
			var arrayLengthMovesList = array_length(valid_moves);
			// From each valid_moves array, grab each moves list (ONLY_ATTACK, ONLY_MOVE, BOTH)
			for (var list = 0; list < arrayLengthMovesList; list++) {
				// Filter out dead arrays
				if valid_moves[list] != undefined && valid_moves[list] != 0 {
					piece_attack(valid_moves[list],list,cost);	 
				}	
			}		
		break;
	}
}
if moved {
	moved = false;
	instance_destroy();
}
skip_move = false;

