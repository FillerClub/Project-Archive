var gridRef = piece_on_grid;
if is_string(gridRef) {
	with obj_grid {
		if tag == gridRef {
			gridRef = id;
			break;
		}
	}
}

if instance_exists(gridRef) {
	x = grid_pos[0]*GRIDSPACE +gridRef.bbox_left;
	y = grid_pos[1]*GRIDSPACE +gridRef.bbox_top;
}

last_damaged += delta_time*DELTA_TO_SECONDS;