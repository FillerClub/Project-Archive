function find_sequence_object(trackStruct,target) {
    if (is_undefined(trackStruct)) return noone;
    var findInstance = trackStruct.instanceID;
    // Draw the instance if it exists
    if instance_exists(findInstance) && findInstance.object_index == target {
		return findInstance;
    }
    // If there are nested active tracks, recurse into them
	var childTracks = trackStruct.activeTracks;
    var len = array_length(childTracks);
    if len > 0 {
        for (var i = 0; i < len; i++) {
			var nestedInst = find_sequence_object(childTracks[i],target);
			if instance_exists(nestedInst) {
				return nestedInst	
			}
        }
    }
	return noone;
}