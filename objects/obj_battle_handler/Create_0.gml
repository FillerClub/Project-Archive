enum AI {
	PIECE =	0,
	GRID = 1,
	COORD = 2
}
timer[MAIN] = 0;
timer[ALERT] = 0;
timer_phase = 0;
ai_pieces = [];
friendly_pieces = [];
ai_valid[AI.PIECE] = [];
ai_valid[AI.COORD] = [];
ai_valid[AI.GRID] = [];
ai_mode = CLOSESTTOBASE;
lane_threat = [];
lane_score = [];
ai_seed = random(100);

