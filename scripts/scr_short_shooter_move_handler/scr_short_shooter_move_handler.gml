function short_shooter_move_handler(){
	valid_moves = piece_database(identity,PIECEDATA.MOVES);
	var gS = GRIDSPACE;
	for (var ii = 0; ii < 4; ++ii) {
		var 
		xFact = 1,
		yFact = 1;
			
		if ii > 1 { yFact = -1;	}
		if (ii +1) mod 2 == 0 { xFact = -1; }
			
		for (var i = 1; i < 3; ++i) {
			if i*xFact != 1 || i*yFact != 1 {
				array_push(valid_moves[ONLY_MOVE],[i*xFact,i*yFact])
			}
			if position_meeting(x +i*gS*xFact,y +i*gS*yFact,obj_obstacle) {
				break;
			}
		}
	}	
}