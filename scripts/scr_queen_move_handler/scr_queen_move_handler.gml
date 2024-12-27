function queen_move_handler (move_type, limit = 99){
	var tM = (team == "friendly")?1:-1,
	gS = GRIDSPACE;
	limit++;
	// Diagonals
	for (var ii = 0; ii < 4; ++ii) {
		var 
		xFact = 1,
		yFact = 1;
			
		if ii > 1 { yFact = -1;	}
		if (ii +1) mod 2 == 0 { xFact = -1; }
			
		for (var i = 1; i < limit; ++i) {
			if i*xFact != 1 || i*yFact != 1 {
				array_push(valid_moves[move_type],[i*xFact,i*yFact])
			}
			if position_meeting(x +i*gS*xFact,y +i*gS*yFact,obj_obstacle) || !position_meeting(x +i*gS*xFact,y +i*gS*yFact,obj_grid){
				break;
			}
		}
	}
	
	// Orthagonals
	for (var iDown = 1; iDown < limit; ++iDown) {
		array_push(valid_moves[move_type],[0,iDown])
		if position_meeting(x,y +iDown*gS,obj_obstacle) || !position_meeting(x,y +iDown*gS,obj_grid) {
			break;
		}
	}
		
	for (var iUp = 1; iUp < limit; ++iUp) {
		array_push(valid_moves[move_type],[0,-iUp])
		if position_meeting(x,y -iUp*gS,obj_obstacle) || !position_meeting(x,y -iUp*gS,obj_grid){
			break;
		}
	}
	
	for (var iLeft = 1; iLeft < limit; ++iLeft) {
		array_push(valid_moves[move_type],[-iLeft,0])
		if position_meeting(x -iLeft*gS,y,obj_obstacle) || !position_meeting(x -iLeft*gS,y,obj_grid) {
			break;
		}
	}
		
	for (var iRight = 1; iRight < limit; ++iRight) {
		array_push(valid_moves[move_type],[iRight,0])
		if position_meeting(x +iRight*gS,y,obj_obstacle) || !position_meeting(x +iRight*gS,y,obj_grid){
			break;
		}
	}
}