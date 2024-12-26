function effect_give(effecttype, effectlength = -1, effectpotency = 1){
	var arLength = array_length(effects_management_array);
	for (var i = 0; i < arLength; i++) {
		if !time_source_exists(effects_management_array[i]) {
			break;
		}		
	}
	effects_management_array[i] = new effect_add(effecttype,effectlength,effectpotency);
	
	var
	tType = effects_management_array[i].type,
	tLength = effects_management_array[i].length,
	tPotency = effects_management_array[i].potency;

	if tLength < 0 {
		tLength = infinity;	
	}
	
	if tType != EFFECT.NOTHING {
		effects_management_array[i] = time_source_create(time_source_game,tLength,time_source_units_seconds,function(array_index,effect_type,effect_potency) {
			effect_destroy(array_index,effect_type,effect_potency);
		},[i,tType,tPotency],1);
	
		//Initalize effect
		effects_array[tType] += tPotency;
		time_source_start(effects_management_array[i])	
	}
}