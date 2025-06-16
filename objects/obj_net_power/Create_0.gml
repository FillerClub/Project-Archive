if !position_meeting(x +GRIDSPACE/2,y +GRIDSPACE/2,obj_generic_piece) {
	instance_destroy();
	exit;
}
with instance_position(x +GRIDSPACE/2,y +GRIDSPACE/2,obj_generic_piece) {
	execute = "force_move";	
	other.piece_link = self;
	skip_move = true;
}
with link {
	pause_cooldown = true;
	cooldown = cooldown_length;
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