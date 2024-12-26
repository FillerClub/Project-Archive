function deal_with_effects(){
	var arLength = array_length(effects_management_array);
	for (var i = 0; i < arLength; i++) {
		if !time_source_exists(effects_management_array[i]) {
			var
			tType = effects_management_array[i].type,
			tLength = effects_management_array[i].length,
			tPotency = effects_management_array[i].potency;
		
			// If the effect is old
			if tType == EFFECT.NOTHING {
				if array_last(effects_management_array) == effects_management_array[i] && i > 0 {
					array_delete(effects_management_array,i,1);
				}
				continue;	
			}
		}
	}
}