with obj_generic_hero {
	if team == other.team {
		other.name = identity;
		other.hp = hp;
	}
}

hlign = (team == "friendly")?fa_left:fa_right;