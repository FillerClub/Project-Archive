if team == global.player_team {
	identity = global.active_hero;
} else if instance_exists(obj_client_manager) {
	with obj_client_manager {
		for (var i = 0; i < array_length(players); i++) {
			if players[i].port == opponent_port {
				other.identity = players[i].hero;
			}
		}
	}	
}
sprite_index = hero_database(identity,HERODATA.SPRITE);

hp = global.barrier_criteria;
hp_init = hp;
