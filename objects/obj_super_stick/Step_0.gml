event_inherited();

if execute = "move" || ai_controlled { 
	valid_moves = piece_database(identity,PIECEDATA.MOVES);
	queen_move_handler(ONLY_ATTACK,2);
}
