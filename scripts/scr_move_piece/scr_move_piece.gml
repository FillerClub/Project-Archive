function r_move_piece(_pos,_grid,_tag,_bypass_cooldown = false) {
	var move = {
		Message: SEND.GAMEDATA,
		action_type: "Move",
		bypass_cooldown: _bypass_cooldown,
		grid_pos: _pos,
		piece_on_grid: _grid,
		tag: _tag,
	}
	with obj_battle_handler {
		array_push(requests,move);
	}
}