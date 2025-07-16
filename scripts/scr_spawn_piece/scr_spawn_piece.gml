function r_spawn_piece(_identity,_team,_grid_pos,_on_grid) {
	var spawn = {
		action: DATA.SPAWN,
		team: _team,
		identity: _identity,
		grid_pos: _grid_pos,
		piece_on_grid: _on_grid,
	}
	with obj_battle_handler {
		array_push(requests,spawn);
	}
}