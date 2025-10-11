// HELPER FUNCTION: Create save data
function create_save_state(buffer = -1) {
    if buffer_exists(buffer) {
		buffer_delete(buffer);	
		buffer = buffer_create(1024,buffer_grow,1);
		buffer_seek(buffer,buffer_seek_start,0);
	}
      
	var saveData = {
        objects: [],
        globals: {},
		version: 1.0, // Ensure you're syncing with updated, non-modded clients
    };
    
    var saveObjects = SAVEOBJECTS;
    var saveVars = SAVEOBJECTVARIABLES;
    var saveGlobals = SAVEGLOBALS;
    
    // Save global variables
    for (var i = 0, len = array_length(saveGlobals); i < len; i++) {
        var globalName = saveGlobals[i];
        if variable_global_exists(globalName) {
            struct_set(saveData.globals, globalName, variable_global_get(globalName));
        }
    }
    
    // Save object instances
    var objIndex = 0;
    for (var objType = 0, objCount = array_length(saveObjects); objType < objCount; objType++) {
        with saveObjects[objType] {
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
            for (var varIndex = 0, varCount = array_length(saveVars); varIndex < varCount; varIndex++) {
                var varName = saveVars[varIndex];
                if variable_instance_exists(id, varName) {
                    struct_set(instanceData, varName, variable_instance_get(id, varName));
                }
            }
			if variable_instance_exists(self,"animation") {
	            if layer_sequence_exists("Instances",animation) { 
					var anim = layer_sequence_get_instance(animation);
					instanceData.starting_sequence = anim.sequence.name;
					instanceData.starting_sequence_pos = anim.headPosition; 	
				}
			}
            saveData.objects[objIndex] = instanceData;
            objIndex++;
        }
    }
	if buffer_exists(buffer) {
		buffer_write(buffer,buffer_string,json_stringify(saveData));
	}
	return saveData;
}

// HELPER FUNCTION: Load save data
function load_save_state(buffer, saveStateTime = -1) {
	var stateData = buffer;
	// Handle cases when we want to load from a provided buffer
	if buffer_exists(buffer) {
		show_debug_message("Loading save state from buffer");
		buffer_seek(buffer,buffer_seek_start,0);
		stateData = json_parse(buffer_read(buffer,buffer_string));
	}
	// Else assume we're just loading from a struct
    if !struct_exists(stateData, "objects") || !struct_exists(stateData, "globals") {
        throw "Invalid save data format";
    }
    
    var saveObjects = SAVEOBJECTS;
    var saveVars = SAVEOBJECTVARIABLES;
    var saveIgnoreVars = SAVEOBJECTIGNOREVARIABLES;
    var saveGlobals = SAVEGLOBALS;
    
    // Restore global variables
    var globalNames = struct_get_names(stateData.globals);
    for (var i = 0, len = array_length(globalNames); i < len; i++) {
        var globalName = globalNames[i];
        if array_contains(saveGlobals, globalName) {
            variable_global_set(globalName, struct_get(stateData.globals, globalName));
        }
    }
    // Create lookup map for existing instances
    var existingInstances = create_instance_lookup(saveObjects);
    
    // Update existing instances and mark which ones to keep
    var instancesToKeep = {};
    for (var i = 0, len = array_length(stateData.objects); i < len; i++) {
        var savedInstance = stateData.objects[i];
        
        if !struct_exists(savedInstance, "tag") continue;
        
        var instanceTag = savedInstance.tag,
		found = false;
		if is_string(instanceTag) {
			with stateData.objects[i].object_index {
				if tag == instanceTag {
					found = true;
					var instanceId = id;
					break;
				}
			}				
		} else {
			with stateData.objects[i].object_index {
				if id == instanceTag {
					found = true;
					var instanceId = id;
					break;
				}	
			}							
		}
		
        if found && struct_exists(existingInstances, string(instanceTag)) {
            // Update existing instance
            update_instance_from_data(instanceId, savedInstance, saveVars, saveIgnoreVars, saveStateTime);
            struct_set(instancesToKeep, string(instanceId), true);
        } else {
            // Create new instance
            var keepID = create_instance_from_data(savedInstance, saveVars, saveIgnoreVars, saveStateTime);
            struct_set(instancesToKeep, string(keepID), true);
        }
    }
    // Destroy instances that weren't in the save data
    destroy_unlisted_instances(saveObjects, instancesToKeep);
}

// HELPER FUNCTION: Create lookup map of existing instances
function create_instance_lookup(saveObjects) {
    var lookup = {};
    for (var objType = 0, objCount = array_length(saveObjects); objType < objCount; objType++) {
        with saveObjects[objType] {
            struct_set(lookup, string(id), true);
        }
    }
    return lookup;
}

// HELPER FUNCTION: Update existing instance from save data
function update_instance_from_data(instanceId, savedData, saveVars, ignoreVars, saveStateTime = -1) {
	var currentTime = get_timer(); 
	with instanceId {
        for (var i = 0, len = array_length(saveVars); i < len; i++) {
            var varName = saveVars[i];
            
            // Skip ignored variables
            if array_contains(ignoreVars, varName) continue;
            if struct_exists(savedData, varName) {
				var valueSet = struct_get(savedData, varName);
				if saveStateTime > 0 && is_int64(valueSet) {
					var isTimeValue = false;
					var timeValues = TIMESENSITIVEVARIABLES;
					for (var t = 0; t < array_length(timeValues); t++) {
						if timeValues[t] == varName {
							isTimeValue = true;
							break;
						}			
					}
					if isTimeValue {
						switch varName {
							case "timer":
								valueSet += (currentTime -saveStateTime)/1000000;
							break;
							default:
								valueSet -= (currentTime -saveStateTime)/1000000;
							break;
						}
					}
				}
                variable_instance_set(id, varName, valueSet);
            }
        }
    }
}

// HELPER FUNCTION: Create new instance from save data
function create_instance_from_data(savedData, saveVars, ignoreVars, saveStateTime = -1) {
    if !struct_exists(savedData, "object_index") || 
       !struct_exists(savedData, "x") || 
       !struct_exists(savedData, "y") || 
       !struct_exists(savedData, "depth") {
        return noone;
    }
	var timeOffset = 0;
	with obj_online_battle_handler {
		timeOffset = game_clock_start;
	}
    var currentTime = get_timer() -timeOffset,
	instanceVariables = {};
	// Set saved variables
    for (var i = 0, len = array_length(saveVars); i < len; i++) {
        var varName = saveVars[i];
        // Skip ignored variables
        if array_contains(ignoreVars, varName) continue;     
        if struct_exists(savedData, varName) {
			var valueSet = struct_get(savedData, varName);
			if saveStateTime > 0 && is_int64(valueSet) {
				var isTimeValue = false;
				var timeValues = TIMESENSITIVEVARIABLES;
				for (var t = 0; t < array_length(timeValues); t++) {
					if timeValues[t] == varName {
						isTimeValue = true;
						break;
					}			
				}
				if isTimeValue {
					switch varName {
						case "timer":
							valueSet += (currentTime -saveStateTime)/1000000;
						break;
						default:
							valueSet -= (currentTime -saveStateTime)/1000000;
						break;
					}
				}
			}
            variable_struct_set(instanceVariables, varName, valueSet);
        }
    }
    with instance_create_depth(savedData.x, savedData.y, savedData.depth, savedData.object_index,instanceVariables) {
        // Stop any placement sounds
        if variable_instance_exists(self, "place_sound") {
            audio_stop_sound(place_sound);
        }
        return id;
    }
}

// HELPER FUNCTION: Destroy instances not in save data
function destroy_unlisted_instances(saveObjects, instancesToKeep) {
    for (var objType = 0, objCount = array_length(saveObjects); objType < objCount; objType++) {
        with saveObjects[objType] {
            if !struct_exists(instancesToKeep, string(id)) {
                instance_destroy(self, false);
            }
        }
    }
}

// UTILITY FUNCTION: Check if array contains value
function array_contains(arrayToCheck, value) {
    for (var i = 0, len = array_length(arrayToCheck); i < len; i++) {
        if arrayToCheck[i] == value return true;
    }
    return false;
}
