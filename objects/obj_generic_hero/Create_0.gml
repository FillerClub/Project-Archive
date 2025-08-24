if team == global.player_team {
	identity = global.active_hero;
} 
if identity == "nothing" {
	identity = global.opponent_hero;	
}
sprite_index = hero_database(identity,HERODATA.SPRITE);

hp = global.barrier_criteria;
hp_init = hp;
