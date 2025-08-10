function effect_generate(target_inst, type, id_string = string_random(3), length = -1, potency = 1, object = noone, decay = false){
	if !instance_exists(target_inst) {
		exit;
	}
	if length < 0 {
		length = infinity;	
	}
	with target_inst {
		if !variable_instance_exists(self,"effects_management_array") || !variable_instance_exists(self,"effects_array") || !variable_instance_exists(self,"effects_timer") {
			continue;
		}
		// Grab current effects timer and add it onto length to "simulate" the age of the buffs
		var fauxLength = length +effects_timer;
		// Create new array at the end of the management array
		var aML = array_length(effects_management_array);
		effects_management_array[aML] = new effect_array_create(type,id_string,fauxLength,potency,object,decay,length);
		// Give initial buff/debuff on the effect array
		effects_array[type] += potency;
		//Special code based on type
		switch type {
			case EFFECT.OVERHEALTH:
				if !variable_struct_exists(hp_max,"over") {
					hp_max.over = potency;	
				}
				if !variable_struct_exists(hp,"over") {
					hp.over = potency;
				} else {
					hp.over += potency;	
				}
				last_damaged = 0;
			break;
		}
	}
}