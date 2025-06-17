function effect_generate(target_inst, type, id_string = string_random(3), length = -1, potency = 1, object = noone){
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
		length += effects_timer;
		// Create new array at the end of the management array
		var aML = array_length(effects_management_array);
		effects_management_array[aML] = new effect_array_create(type,id_string,length,potency,object);
		// Give buff/debuff on the effect array
		effects_array[type] += potency;
	}
}