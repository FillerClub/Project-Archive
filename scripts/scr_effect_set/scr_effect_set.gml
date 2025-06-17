function effect_set(target_inst, id_string = -1, object = -1, type = -1, length = -1, potency = 1){
	// Primarily match by ID
	if !instance_exists(target_inst) {
		exit;
	}
	var deleteNotModify = (length <= 0 || potency <= 0)?true:false;
	with target_inst {
		if !variable_instance_exists(self,"effects_management_array") || !variable_instance_exists(self,"effects_array") || !variable_instance_exists(self,"effects_timer") {
			continue;
		}
		// Scan through to see if it needs to reset existing 
		var aMR = array_length(effects_management_array),
		reset = false,
		completelyNew = true;
		for (var i = 0; i < aMR; i++) {
			reset = false;
			if type != -1 {
				if effects_management_array[i].type == type {
					completelyNew = false;
					reset = true;
				} else {
					reset = false;	
				}
			}
			if object != -1 {
				if effects_management_array[i].object == object {
					completelyNew = false;
					reset = true;
				} else {
					reset = false;	
				}
			}
			if id_string != -1 {
				if effects_management_array[i].id_string == id_string {
					completelyNew = false;
					reset = true;
				} else {
					reset = false;	
				}
			}
			if !reset {
				continue;	
			}
			if deleteNotModify {
				// Setting length to 0 effectively removes the effect
				effects_management_array[i].length = 0;	
			} else {
				// Use clamp because don't want length to go over more time than it needs
				if length > 0 {
					effects_management_array[i].length = clamp(effects_management_array[i].length +length,0,effects_timer +length);	
				}
				if potency > 0 {
					effects_management_array[i].potency = potency;
				}
			}
		}
		if completelyNew {
			effect_generate(target_inst,type,id_string,length,potency,object);
		}
	}
}