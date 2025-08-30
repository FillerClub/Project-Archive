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