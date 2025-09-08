function r_spawn_piece(_identity,_team,_index,_grid_pos,_on_grid,_type,_link) {
	var spawn = {
		Message: SEND.GAMEDATA,
		action: "Spawn",
		type: _type,
		team: _team,
		index: _index,
		identity: _identity,
		grid_pos: _grid_pos,
		piece_on_grid: _on_grid,
		link: _link,
		tag: generate_tag(4) // Generate a random tag to identity pieces for online play
	}
	with obj_battle_handler {
		array_push(requests,spawn);
	}
}