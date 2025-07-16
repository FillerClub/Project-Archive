function r_move_piece(_pos,_grid,_tag) {
	var move = {
		action: DATA.MOVE,
		grid_pos: _pos,
		piece_on_grid: _grid,
		tag: _tag,
	}
	with obj_battle_handler {
		array_push(requests,move);
	}
}