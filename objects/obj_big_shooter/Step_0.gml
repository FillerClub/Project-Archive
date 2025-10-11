event_inherited();

if execute = "move" || ai_controlled { 
	valid_moves = piece_database(identity,"moves");
	queen_move_handler(BOTH);
}

