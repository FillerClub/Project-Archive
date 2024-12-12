function tm_dp(value, team = "friendly", flip = 0) {
	var returnValue = 0;
	if flip { flip = -1 } else { flip = 1 }
	switch team {
		case "friendly":
			returnValue = flip*value;
		break;
		
		case "enemy":
			returnValue = -flip*value;
		break;
		
		default:
			returnValue = undefined;
		break;
	}
	return returnValue;
}