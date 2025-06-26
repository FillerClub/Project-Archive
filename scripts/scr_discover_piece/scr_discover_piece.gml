function discover_piece(piecePush) {
	if typeof(piecePush) == "string" {
		var 
		isNew = true,
		discPiece = global.discovered_pieces,
		lengthDiscover = array_length(discPiece);
		for (var i = 0; i < lengthDiscover; i++) {
			if discPiece[i] == piecePush {
				isNew = false;
			}
		}
		
		if isNew {
			array_push(global.discovered_pieces,piecePush);
			save_file(SAVEFILE);
		}
	}	
}