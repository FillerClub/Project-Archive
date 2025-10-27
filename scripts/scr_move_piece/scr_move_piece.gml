function r_move_piece(_tag,_pos,_grid,_o_pos = [-1,-1],_o_grid = noone,_bypass_cooldown = false) {
	
	var move = {
		Message: SEND.GAMEDATA,
		action_type: "Move",
		tag: _tag,
		time_stamp: 0,
		o_grid_pos: _o_pos,
		o_piece_on_grid: _o_grid,
		grid_pos: _pos,
		piece_on_grid: _grid,
		bypass_cooldown: _bypass_cooldown
	}
	with obj_battle_handler {
		move.time_stamp = get_timer() -game_clock_start;
		array_push(requests,move);
	}
}