function r_spawn_piece(_identity,_team,_grid_pos,_on_grid) {
	var spawn = {
		Message: SEND.GAMEDATA,
		action: "Spawn",
		team: _team,
		identity: _identity,
		grid_pos: _grid_pos,
		piece_on_grid: _on_grid,
		tag: string_random(4)
	}
	with obj_battle_handler {
		array_push(requests,spawn);
	}
}