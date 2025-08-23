function team_colours(team){
	switch team {
		case "friendly":
			return #7FFFFF;

		case "enemy":
			return #EE2F36;

		default:
			return c_white;	
	}
}