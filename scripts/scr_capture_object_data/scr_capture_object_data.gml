function capture_object_data(save_object_array,save_variable_array) {
	var objIndex = 0;
	var saveDataSend = [];
    for (var objType = 0, objCount = array_length(save_object_array); objType < objCount; objType++) {
        with save_object_array[objType] {
            // Must have variables
			var instanceData = {
                object_index: object_index,
				depth: depth,
                x: x,
                y: y,
            };
			if variable_instance_exists(self,"tag") {
				instanceData.tag = tag;	
			} else {
				instanceData.tag = id;
			}
            // Save specified variables
            for (var varIndex = 0, varCount = array_length(save_variable_array); varIndex < varCount; varIndex++) {
                var varName = save_variable_array[varIndex];
                if variable_instance_exists(self, varName) {
                    struct_set(instanceData, varName, variable_instance_get(self, varName));
                }
            }
			if variable_instance_exists(self,"animation") {
	            if layer_sequence_exists("Instances",animation) { 
					var anim = layer_sequence_get_instance(animation);
					instanceData.starting_sequence = anim.sequence.name;
					instanceData.starting_sequence_pos = anim.headPosition; 	
				}
			}
            saveDataSend[objIndex] = instanceData;
            objIndex++;
        }
	}
	return saveDataSend;
}