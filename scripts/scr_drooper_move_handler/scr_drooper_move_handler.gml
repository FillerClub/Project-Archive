function drooper_move_handler(){
	var tM = (team == "friendly")?1:-1,
	gS = GRIDSPACE;

	valid_moves = piece_database(identity,PIECEDATA.MOVES);

	
	for (var iDown = 1; iDown < 99; ++iDown) {
		array_push(valid_moves[ONLY_ATTACK],[0,iDown])
		if position_meeting(x,y +iDown*gS,obj_obstacle) || !position_meeting(x,y +iDown*gS,obj_grid) {
			break;
		}
	}
		
	for (var iUp = 1; iUp < 99; ++iUp) {
		array_push(valid_moves[ONLY_ATTACK],[0,-iUp])
		if position_meeting(x,y -iUp*gS,obj_obstacle) || !position_meeting(x,y -iUp*gS,obj_grid){
			break;
		}
	}
}