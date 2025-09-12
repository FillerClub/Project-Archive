/// @desc Draw piece animation
gpu_push_state();
gpu_set_blendenable(true);
gpu_set_blendmode_ext(bm_src_alpha, bm_inv_src_alpha);

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
var drawDebug = instance_exists(obj_debugger) && obj_debugger.debug_overlay && is_predicted;
if drawDebug {
	// Draw prediction indicator
	draw_set_alpha(0.5);
	draw_set_color(c_yellow);
	draw_circle(x +GRIDSPACE/2, y +GRIDSPACE/2, 32, false);
	draw_set_alpha(1);
        
	// Draw confidence
	var confidence_color = prediction_confidence > 0.8 ? c_green : 
	                        (prediction_confidence > 0.5 ? c_yellow : c_red);
}

if layer_sequence_exists("Instances", animation) {
    var anim = layer_sequence_get_instance(animation),
        animTracks = anim.activeTracks,
        tracks = array_length(animTracks);
    
    for (var t = 0; t < tracks; t++) {
        piece_draw_components(animTracks[t], zOff, abs(xScale), yScale, col, tick);
    }    
} else {
	var offsetVar = clamp(xFlip,-1,0);
    var draw_x = x -sprite_xoffset*xFlip -sprite_width*offsetVar;
    var draw_y = y -sprite_yoffset -zOff;
    
    draw_sprite_general(sprite_index, image_index, 
                       0, 0, sprite_width, sprite_height,
                       draw_x, draw_y, 
                       xScale, yScale, 0, 
                       col, col, col, col, tick);
}
if drawDebug {
	draw_set_color(confidence_color);
	draw_text(x - 16, y - 16, string(round(prediction_confidence * 100)) + "%");
}
// Restore previous GPU state
gpu_pop_state();