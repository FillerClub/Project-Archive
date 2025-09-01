// SAVE STATE (Enter key)
if keyboard_check_pressed(vk_enter) {
    try {
		if buffer_exists(save_buffer) {
			buffer_delete(save_buffer);	
		}
		save_buffer = buffer_create(1024,buffer_grow,1);
		buffer_seek(save_buffer,buffer_seek_start,0);
        var saveData = create_save_data();
		buffer_write(save_buffer,buffer_string,json_stringify(saveData));
        create_system_message(["Game state saved"],TOP,false);
    } catch (error) {
        create_system_message(["Save failed: " + string(error.message)],TOP,false);
    }
}

// LOAD STATE (Backspace key)
if keyboard_check_pressed(vk_backspace) && buffer_exists(save_buffer) {
    try {
		buffer_seek(save_buffer,buffer_seek_start,0);
        var stateData = json_parse(buffer_read(save_buffer,buffer_string));
        load_save_data(stateData);
        create_system_message(["Game state loaded"],TOP,false);
    } catch (error) {
        create_system_message(["Load failed: " + string(error.message)],TOP,false);
    }
}

// HELPER FUNCTION: Create save data
function create_save_data() {
    var saveData = {
        objects: [],
        globals: {},
        version: 1.0  // For future compatibility
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
                id: id,
                object_index: object_index,
                x: x,
                y: y,
                depth: depth
            };

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
    return saveData;
}

// HELPER FUNCTION: Load save data
function load_save_data(stateData) {
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
        
        if !struct_exists(savedInstance, "id") continue;
        
        var instanceId = savedInstance.id;
        
        if struct_exists(existingInstances, string(instanceId)) {
            // Update existing instance
            update_instance_from_data(instanceId, savedInstance, saveVars, saveIgnoreVars);
            struct_set(instancesToKeep, string(instanceId), true);
        } else {
            // Create new instance
            var keepID = create_instance_from_data(savedInstance, saveVars, saveIgnoreVars);
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
function update_instance_from_data(instanceId, savedData, saveVars, ignoreVars) {
    with instanceId {
        for (var i = 0, len = array_length(saveVars); i < len; i++) {
            var varName = saveVars[i];
            
            // Skip ignored variables
            if array_contains(ignoreVars, varName) continue;
            
            if struct_exists(savedData, varName) {
                variable_instance_set(id, varName, struct_get(savedData, varName));
            }
        }
    }
}

// HELPER FUNCTION: Create new instance from save data
function create_instance_from_data(savedData, saveVars, ignoreVars) {
    if !struct_exists(savedData, "object_index") || 
       !struct_exists(savedData, "x") || 
       !struct_exists(savedData, "y") || 
       !struct_exists(savedData, "depth") {
        return noone;
    }
    
    with instance_create_depth(savedData.x, savedData.y, savedData.depth, savedData.object_index) {
        // Stop any placement sounds
        if variable_instance_exists(self, "place_sound") {
            audio_stop_sound(place_sound);
        }
        
        // Set saved variables
        for (var i = 0, len = array_length(saveVars); i < len; i++) {
            var varName = saveVars[i];
            
            // Skip ignored variables
            if array_contains(ignoreVars, varName) continue;
            
            if struct_exists(savedData, varName) {
                variable_instance_set(id, varName, struct_get(savedData, varName));
            }
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
/*
if keyboard_check_pressed(vk_enter) {
	var infoArray = {objects: [], globals: []},
	index2 = 0,
	saveObjects = SAVEOBJECTS,
	objAmt = array_length(saveObjects),
	saveVars = SAVEOBJECTVARIABLES,
	varAmt = array_length(saveVars),
	structSave = {},
	saveGlobals = SAVEGLOBALS,
	saveGlobalAmt = array_length(saveGlobals);
	for (var g = 0; g < saveGlobalAmt; g++) {
		infoArray.globals[g] = variable_global_get(saveGlobals[g]);
	}
	for (var s = 0; s < objAmt; s++) {
		with saveObjects[s] {
			struct_set(structSave,"id",id);
			for (var sv = 0; sv < varAmt; sv++) {
				if variable_instance_exists(id,saveVars[sv]) {
					struct_set(structSave,saveVars[sv],variable_instance_get(id,saveVars[sv]));
				}
			}
			infoArray.objects[index2] = structSave;
			structSave = {};
			index2++;
		}		
	}
	global.save_state = json_stringify(infoArray);
	create_system_message(["Game state saved"]);
}

if keyboard_check_pressed(vk_backspace) && global.save_state != "" {
	var stateArray = json_parse(global.save_state),
	arrayLength = array_length(stateArray.objects),
	saveVars = SAVEOBJECTVARIABLES,
	saveIgnoreVars = SAVEOBJECTIGNOREVARIABLES,
	saveIgnoreVarsLeng = array_length(saveIgnoreVars),
	saveObjects = SAVEOBJECTS,
	objAmt = array_length(saveObjects),
	varAmt = array_length(saveVars),
	ignore = false,
	objectFound = false,
	saveGlobals = SAVEGLOBALS,
	saveGlobalAmt = array_length(saveGlobals);
	for (var g = 0; g < saveGlobalAmt; g++) {
		variable_global_set(saveGlobals[g],stateArray.globals[g])
	}
	for (var s = 0; s < objAmt; s++) {
		with saveObjects[s] {
			objectFound = false;
			for (var l = 0; l < arrayLength; l++) {
				var ref = stateArray.objects[l];
				if !struct_exists(ref,"id") {
					continue;	
				}
				if id != ref.id {
					continue;	
				}
				objectFound = true;
				for (var sv = 0; sv < varAmt; sv++) {
					ignore = false;
					for (var i = 0; i < saveIgnoreVarsLeng; i++ ) {
						if saveVars[sv] == saveIgnoreVars[i] {
							ignore = true;
							break;
						}
					}
					if ignore {
						continue;	
					}
					if struct_exists(ref,saveVars[sv]) {
						variable_instance_set(id,saveVars[sv],struct_get(ref,saveVars[sv]))
					}
				}	
			}
			if !objectFound {
				instance_destroy(self,false);	
			}
		}		
	}
	for (var l = 0; l < arrayLength; l++) {
		var ref = stateArray.objects[l];
		if !instance_exists(ref.id) {
			with instance_create_depth(ref.x,ref.y,ref.depth,ref.object_index) {
				if variable_instance_exists(self,"place_sound") {
					audio_stop_sound(place_sound);
				}
				for (var sv = 0; sv < varAmt; sv++) {
					ignore = false;
					for (var i = 0; i < saveIgnoreVarsLeng; i++ ) {
						if saveVars[sv] == saveIgnoreVars[i] {
							ignore = true;
							break;
						}
					}
					if ignore {
						continue;	
					}
					if struct_exists(ref,saveVars[sv]) {
						variable_instance_set(id,saveVars[sv],struct_get(ref,saveVars[sv]))
					}
				}				
			}
		}
	}
}