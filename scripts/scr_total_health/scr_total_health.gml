function total_health(hp_struct){
	checkTotalHP = 0; 
	struct_foreach(hp_struct,function(_name,_value) {
		checkTotalHP += _value;
	});
	return checkTotalHP;
}

function total_effective_health(hp_struct) {
    // Define mitigation behavior per HP type, also defines order
    var types = ["over", "shield", "armor", "base"],
	cum = 0,
	mitigation = {
		over: function(dmg,invert = false) { return dmg; },   						
		shield: function(dmg,invert = false) { return invert?sqr(dmg):sqrt(dmg); }, 
		armor: function(dmg, invert = false) { return invert?dmg*2:dmg/2; },		
		base: function(dmg, invert = false) { return dmg; }	      
	}
    for (var i = 0; i < array_length(types); i++) {
        if variable_struct_exists(hp_struct, types[i]) {
            var hp_val = struct_get(hp_struct, types[i]);
			var mitigate = struct_get(mitigation, types[i]);
			if is_undefined(mitigate) mitigate = function(dmg,invert = false) { return dmg; }
			// Cummulate hp
            cum += mitigate(hp_val,true);
        }
    }
	return cum;
}
