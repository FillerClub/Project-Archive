/// @desc Generic piece code for movement
if !piece() || skip_move {
	skip_move = false;
	exit;	
}
switch execute {
	case "move":
		var arrayLengthMovesList = array_length(valid_moves);
		// From each valid_moves array, grab each moves list (ONLY_ATTACK, ONLY_MOVE, BOTH)
		for (var list = 0; list < arrayLengthMovesList; list++) {
			// Filter out dead arrays
			if valid_moves[list] == undefined || valid_moves[list] == 0 {
				continue;	
			}
			piece_attack(valid_moves[list],list,cost,false,skip_click);
		}		
	break;
}

if moved {
	moved = false;	
}