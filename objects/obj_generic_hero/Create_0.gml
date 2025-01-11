if team == global.team {
	identity = global.active_hero;
}
sprite_index = hero_database(identity,HERODATA.SPRITE);

hp = global.max_barriers;
hp_init = hp;
