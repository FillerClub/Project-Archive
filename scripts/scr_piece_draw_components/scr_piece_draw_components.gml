function piece_draw_components(trackStruct,zOff,xScale,yScale,col,tick) {
/// @func draw_anim_track(trackStruct)
/// @desc Recursively draws sprites for a track and all nested subtracks.
    if (is_undefined(trackStruct)) return;
    var drawInstance = trackStruct.instanceID;
    // Draw the instance if it exists
    if (instance_exists(drawInstance)) {
        with (drawInstance) {
			var netYScale = yScale;
			if is_eyes {
				netYScale *= other.eye_scale_fact;	
			}
			var final_alpha = tick * image_alpha;
			if final_alpha <= 0 {
				break;
			}
            draw_sprite_ext(
                sprite_index,
                image_index,
                x,
                y -zOff,
                xScale*image_xscale,
                netYScale*image_yscale,
                image_angle,
                col,
                tick*image_alpha
            );
        }
    }
    // If there are nested active tracks, recurse into them
	var childTracks = trackStruct.activeTracks;
    var len = array_length(childTracks);
    if len > 0 {
        for (var i = 0; i < len; i++) {
           piece_draw_components(childTracks[i],zOff,xScale,yScale,col,tick);
        }
    }
}