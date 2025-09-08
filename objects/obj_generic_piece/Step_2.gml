/// @desc Push effects for another object to draw
var tM = (team == "enemy") ? -1 : 1,
    col = team_colours(team),
    sPD = effects_array[EFFECT.SPEED],
    sLW = effects_array[EFFECT.SLOW];

var zBase = 0;
if instance_exists(piece_on_grid) {
    zBase = piece_on_grid.z;    
}

var xFlip = (1 - toggle * 2) * tM,
    xScale = (1 + ai_timer / (TIMETOTAKE * 2)) * xFlip,
    yScale = (1 + ai_timer / (TIMETOTAKE * 2)),
    tick = invincible_tick,
    zOff = zBase + z;

var origXoffset = sprite_xoffset,
    origYoffset = sprite_yoffset,
    shadowSize = 1 / (max(0, log2(z / 64 + 0.5)) + 1);

with obj_piece_move_highlighter {
	var ref = other;
	// Collect shadow data instead of drawing directly	
	add_shadow_data(ref, shadowSize, zBase);
	// Collect effect data instead of drawing directly  
	add_effect_data(ref.x, ref.y, sPD, sLW, zOff);
	// Collect timer data instead of drawing directly
	if ref.move_cooldown_timer > 0 {
		var timer_x = ref.x + ref.sprite_width/2 - origXoffset;
		var timer_y = ref.y + ref.sprite_height/2 - origYoffset - zBase;
		add_timer_data(timer_x, timer_y, ref.move_cooldown_timer/ref.move_cooldown, ref.timer_color);	
	}
}