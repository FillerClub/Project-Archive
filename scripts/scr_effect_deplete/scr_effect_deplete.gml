function effect_deplete(target_inst, match_id = -1, match_type = -1, by_length = -1, by_potency = -1) {
	if !instance_exists(target_inst) {
		exit;
	}
	var deleteNotModify = (by_length < 0 || by_potency < 0) || (by_length <= 0 && by_potency <= 0)?true:false;
	with target_inst {
		if !variable_instance_exists(self,"effects_management_array") || !variable_instance_exists(self,"effects_array") || !variable_instance_exists(self,"effects_timer") {
			continue;
		}
		var aMR = array_length(effects_management_array),
		target = true;
		for (var i = 0; i < aMR; i++) {
			// Check if matches ID, if necessary
			if match_id != -1 && effects_management_array[i].id_string != match_id {
				target = false;
			}
			// Check if matches type, if necessary
			if match_type != -1 && effects_management_array[i].type != match_type {
				target = false;
			}
			// If they don't match when they apply, don't deplete
			if !target {
				continue;	
			}
			if deleteNotModify {
				// Setting length to 0 effectively removes the effect
				effects_management_array[i].length = 0;	
			} else {
				if by_length > 0 {
					effects_management_array[i].length = max(0,effects_management_array[i].length -by_length);	
				}
				if by_potency > 0 {
					effects_management_array[i].potency = max(0,effects_management_array[i].potency -by_potency);
				}
			}
		}
	}
}