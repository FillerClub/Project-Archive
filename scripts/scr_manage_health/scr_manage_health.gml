function manage_health(){
	struct_foreach(hp,function(_name,_value) {
		if !variable_struct_exists(hp_max,_name) {
			struct_remove(hp,_name);
			exit;
		}
		// If it has no base hp, destroy
		switch _name {
			case "base":
				if hp.base <= 0 {
					instance_destroy();
				}
			break;
		}
		// Incase it has no base HP (for whatever reason)
		if total_health(hp) <= 0 {
			instance_destroy();
		}
		// Cap HPs to their respective maxes
		var getHP = struct_get(hp,_name),
		getHPMax = struct_get(hp_max,_name);
		if getHP > getHPMax {
			struct_set(hp,_name,getHPMax)	
		}
	});
	
}