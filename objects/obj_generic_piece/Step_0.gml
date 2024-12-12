/// @desc Generic piece code for movement
if piece() && !skip_move {
	switch execute {
		case "move":
			var arrayLengthMovesList = array_length(valid_moves);
			// From each valid_moves array, grab each moves list (ONLY_ATTACK, ONLY_MOVE, BOTH)
			for (var list = 0; list < arrayLengthMovesList; list++) {
				// Filter out dead arrays
				if valid_moves[list] != undefined && valid_moves[list] != 0 {
					if piece_attack(valid_moves[list],list,cost) {
						moved = true;
						audio_play_sound(snd_move,0,0);	
						execute = "move";
					} 
				}	
			}		
		break;
	}
}
skip_move = false;

