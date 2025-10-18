/// @desc Push information for drawing
var tM = (team == "enemy") ? -1 : 1,
    col = team_colours(team),
    sPD = effects_array[EFFECT.SPEED],
    sLW = effects_array[EFFECT.SLOW];

var zBase = 0;
var gridOff = piece_on_grid;
if is_string(gridOff) {
	with obj_grid {
		if tag == gridOff {
			zBase += z;
			break;
		}
	}
} else if instance_exists(gridOff) { zBase += gridOff.z; }

var xFlip = (1 - toggle * 2) * tM,
    xScale = (1 + ai_timer / (TIMETOTAKE * 2)) * xFlip,
    yScale = (1 + ai_timer / (TIMETOTAKE * 2)),
    tick = invincible_tick,
    zOff = zBase + z;

var origXoffset = x -bbox_left,
    origYoffset = y -bbox_top,
    shadowSize = 1 / (max(0, log2(z / 64 + 0.5)) + 1);

with obj_piece_move_highlighter {
	var ref = other;
	// Collect shadow data instead of drawing directly	
	add_shadow_data(ref, shadowSize, zBase);
	if ref.effects_change_timer {
		// Collect effect data instead of drawing directly  
		add_effect_data(ref.x, ref.y, sPD, sLW, zOff);
	}
	// Collect timer data instead of drawing directly
	if ref.move_cooldown_timer > 0 {
		var timer_x = ref.x +(ref.bbox_left -ref.bbox_right)/2 - origXoffset +GRIDSPACE;
		var timer_y = ref.y +(ref.bbox_bottom -ref.bbox_top)/2 - origYoffset - zBase;
		add_timer_data(timer_x, timer_y, ref.move_cooldown_timer/ref.move_cooldown, ref.timer_color);	
	}
}