/// @func draw_anim_track(track_struct)
/// @desc Recursively draws sprites for a track and all nested subtracks.
function piece_draw_components(track_struct,z_off,x_scale,y_scale,col,tick,interpolation_data, interpolation_lerp) {
    if is_undefined(track_struct) return;
    var drawInstance = track_struct.instanceID;
    // Draw the instance if it exists
    if instance_exists(drawInstance) {
        with (drawInstance) {
			// Check for interpolation data
			var renderX = x,
			renderY = y,
			renderXscale = image_xscale,
			renderYscale = image_yscale,
			renderAlpha = image_alpha,
			renderAngle = image_angle;
			
			if ds_map_size(interpolation_data) > 0 && interpolation_lerp < 1 {
				if ds_map_exists(interpolation_data,object_index) {
					var iData = ds_map_find_value(interpolation_data,object_index);
					if interpolate_x { renderX = lerp(iData.x,renderX,interpolation_lerp); }
					if interpolate_y { renderY = lerp(iData.y,renderY,interpolation_lerp); }
					renderXscale = lerp(iData.image_xscale,renderXscale,interpolation_lerp);
					renderYscale = lerp(iData.image_yscale,renderYscale,interpolation_lerp);
					if interpolate_image_angle { var angleDiff = angle_difference(iData.image_angle, renderAngle); renderAngle = iData.image_angle - angleDiff*interpolation_lerp; }
					renderAlpha = lerp(iData.image_alpha,renderAlpha,interpolation_lerp);
					//show_debug_message(string({renderX,renderY,renderXscale,renderYscale,renderAlpha,renderAngle}) +"   " +string(iData))
				}
			}
			var netYScale = y_scale;
			if variable_instance_exists(self,"is_eyes") {
				if is_eyes {
					netYScale *= other.eye_scale_fact;	
				}
			}
			if variable_instance_exists(self,"override_color") {
				col = override_color;	
			}
			var final_alpha = tick * image_alpha;
			if final_alpha <= 0 {
				break;
			}
			if sprite_index == -1 {
				break;	
			}

            draw_sprite_ext(
                sprite_index,
                image_index,
                renderX,
                renderY -z_off,
                x_scale*renderXscale,
                netYScale*renderYscale,
                renderAngle,
                col,
                tick*renderAlpha
            );
        }
    }
    // If there are nested active tracks, recurse into them
	var childTracks = track_struct.activeTracks;
    var len = array_length(childTracks);
    if len > 0 {
        for (var i = 0; i < len; i++) {
           piece_draw_components(childTracks[i],z_off,x_scale,y_scale,col,tick,interpolation_data,interpolation_lerp);
        }
    }
}