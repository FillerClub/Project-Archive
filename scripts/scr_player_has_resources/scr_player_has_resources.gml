function player_has_resources(team, identity){
	var lookupCost = piece_database(identity,"place_cost")
	switch team {
		case "friendly":
			if global.friendly_turns >= lookupCost {
				return true;	
			}
		break;
		case "enemy":
			if global.enemy_turns >= lookupCost {
				return true;	
			}
		break;
	}
	return false;
}