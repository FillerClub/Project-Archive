/// @desc Draw piece animation
gpu_push_state();
gpu_set_blendenable(true);
gpu_set_blendmode_ext(bm_src_alpha, bm_inv_src_alpha);

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

// Restore previous GPU state
gpu_pop_state();