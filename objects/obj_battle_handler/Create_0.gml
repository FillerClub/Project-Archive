enum AI {
	PIECE =	0,
	GRID = 1,
	COORD = 2
}
game_clock_start = get_timer();
timer = 0;
alert_timer = 0;
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

var gameSpd = game_get_speed(gamespeed_fps)/global.level_speed;

dash_part = part_type_create();
part_type_sprite(dash_part, spr_dash, true, false, false);
part_type_life(dash_part, gameSpd*3, gameSpd*3);
part_type_scale(dash_part, .25, .25);
part_type_size(dash_part,1,1,.03,0);
part_type_speed(dash_part,.9,.9,-0.01,0);
part_type_alpha2(dash_part,1,0);

bullet_part = part_type_create();
part_type_shape(bullet_part, pt_shape_pixel);
part_type_scale(bullet_part, 3, 3);
part_type_size(bullet_part,1,1,-.05,0);
//part_type_alpha2(bullet_part,1,0);
part_type_life(bullet_part, gameSpd*.05, gameSpd*.05);
part_type_blend(bullet_part, true);