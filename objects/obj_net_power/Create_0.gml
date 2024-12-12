with instance_position(x,y,obj_generic_piece) {
	execute = "force_move";	
	other.piece_link = self;
	skip_move = true;
}
with link {
	usable = true;	
}

valid_moves[ONLY_MOVE] = [	[0,0],
							[0, 1],
							[0, 2],
							[0, -1],
							[0, -2],
							[1, 0],
							[1, 1],
							[1, 2],
							[1, -1],
							[1, -2],
							[2, 0],
							[2, 1],
							[2, 2],
							[2, -1],
							[2, -2],
							[-1, 0],
							[-1, 1],
							[-1, 2],
							[-1, -1],
							[-1, -2],
							[-2, 0],
							[-2, 1],
							[-2, 2],
							[-2, -1],
							[-2, -2]];