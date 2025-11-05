function r_spawn_piece(_identity,_team,_index,_grid_pos,_on_grid,_type,_link) {
	var timeDiff = 0;
	with obj_battle_handler {
		timeDiff = game_clock_start;
	}	
	var spawn = {
		Message: SEND.GAMEDATA,
		action_type: "Spawn",
		type: _type,
		team: _team,
		index: _index,
		identity: _identity,
		grid_pos: _grid_pos,
		piece_on_grid: _on_grid,
		link: _link,
		time_stamp: get_timer() -timeDiff,
		tag: generate_tag(5) // Generate a random tag to identity pieces for online play
	}
	with obj_battle_handler {
		array_push(requests,spawn);
	}
}