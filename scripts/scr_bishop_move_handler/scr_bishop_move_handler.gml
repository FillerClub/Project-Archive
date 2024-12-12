function bishop_move_handler(){
	var tM = (team == "friendly")?1:-1,
	gS = global.grid_spacing;

	valid_moves = refer_database(identity,MOVES);

	for (var ii = 0; ii < 4; ++ii) {
		var 
		xFact = 1,
		yFact = 1;
			
		if ii > 1 { yFact = -1;	}
		if (ii +1) mod 2 == 0 { xFact = -1; }
			
		for (var i = 1; i < 7; ++i) {
			if i*xFact != 1 || i*yFact != 1 {
				array_push(valid_moves[BOTH],[i*xFact,i*yFact])
			}
			if position_meeting(x +i*gS*xFact,y +i*gS*yFact,obj_obstacle) || !position_meeting(x +i*gS*xFact,y +i*gS*yFact,obj_grid){
				break;
			}
		}
	}
}