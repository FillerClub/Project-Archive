function create_piece_interpolation_data(track_struct,interpolation_map) {
    if is_undefined(track_struct) return;
    var interpolateInstance = track_struct.instanceID;
    // Draw the instance if it exists
    if instance_exists(interpolateInstance) {
		with interpolateInstance {
			ds_map_set(interpolation_map,interpolateInstance.object_index, {
				x: x,
				y: y,
				image_xscale: image_xscale,
				image_yscale: image_yscale,
				image_alpha: image_alpha,
				image_angle: image_angle
			})
		}
    }
    // If there are nested active tracks, recurse into them
	var childTracks = track_struct.activeTracks;
    var len = array_length(childTracks);
    if len > 0 {
        for (var i = 0; i < len; i++) {
           create_piece_interpolation_data(childTracks[i],interpolation_map);
        }
    }
}