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

bullet_part = part_type_create();
part_type_shape(bullet_part, pt_shape_pixel);
part_type_size(bullet_part, 1, 1, 0, 0);
part_type_scale(bullet_part, 2, 2);
part_type_colour3(bullet_part, #FFFFFF, #FFFFFF, #FFFFFF);
part_type_alpha3(bullet_part,1, .5, 0);
part_type_speed(bullet_part, 0, 0, 0, 0);
part_type_direction(bullet_part, 0, 0, 0, 0);
part_type_gravity(bullet_part, 0, 0);
part_type_orientation(bullet_part, 0, 0, 0, 0, 1);
part_type_blend(bullet_part, false);
//part_type_life(bullet_part,10*delta_time*DELTA_TO_SECONDS,10*delta_time*DELTA_TO_SECONDS);