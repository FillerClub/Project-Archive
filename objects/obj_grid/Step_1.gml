if team != "neutral" && global.game_state != PAUSED {
	timer += delta_time*DELTA_TO_SECONDS;
	var flip = (team == "friendly")?1:-1;
	y = oY +sin(timer)*GRIDSPACE*1.5*flip;
}