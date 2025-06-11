if piece_on_grid != noone {
	if instance_exists(piece_on_grid) {
		x = grid_pos[0]*GRIDSPACE +piece_on_grid.bbox_left;
		y = grid_pos[1]*GRIDSPACE +piece_on_grid.bbox_top;
	} else {
		//on_grid = noone;	
	}
}

