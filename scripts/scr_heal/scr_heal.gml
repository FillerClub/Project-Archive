function heal(hp_struct,hp_struct_max,amount,increase_max_health = false) {
	var raw_healing = abs(amount); 
    // Copied code from hurt function, defines order, probably not going to use to define healing behavior
    var types = ["base","armor","gel","shield","rainbow","over"],
	filtering = {
		base: function(hL,invert = false) { return hL; },	
		armor: function(hL,invert = false) { return hL; },
		gel: function(hL,invert = false) { return hL; },
		shield: function(hL,invert = false) { return hL; },
		rainbow: function(hL,invert = false) { return hL/2; },
		over: function(hL,invert = false) { return 0; },	      
	}
    for (var i = 0; i < array_length(types); i++) {
        if variable_struct_exists(hp_struct, types[i]) && variable_struct_exists(hp_struct_max, types[i]) {
            var hp_val = struct_get(hp_struct, types[i]);
            var hp_max_val = struct_get(hp_struct_max, types[i]);
			
			if hp_val >= hp_max_val { continue; }
			
			var filter = struct_get(filtering, types[i]);
			if is_undefined(filter) filter = function(hL,invert = false) { return hL; };
			var filtered = filter(raw_healing);
			
            // Apply filtered healing to current hp type
			if increase_max_health {
				hp_max_val = max(hp_val +filtered, hp_max_val);
				struct_set(hp_struct_max,types[i],hp_max_val);
			}
            var toHeal = min(filtered, hp_max_val -hp_val);
            struct_set(hp_struct,types[i],hp_val +toHeal);
			
			raw_healing -= filter(toHeal,true);
            // If all filtered healing was absorbed, stop
            if raw_healing <= 0 {
                exit;
            }
            // Else, move on to next HP type, but pass in the original raw_damage again
        }
    }
}

function hurt(hp_struct,amount,type = DAMAGE.NORMAL,object = self) {
	var raw_damage = abs(amount),
	damaged = false;
    // Define mitigation behavior per HP type, also defines order
    var types = ["over", "rainbow", "shield", "gel", "armor", "base"],
	mitigation = {
		over: function(dmg,typ, invert = false) { return dmg; },   						
		rainbow: function(dmg,typ, invert = false) { 
			switch typ {
				case DAMAGE.ENERGY:
					return invert?max(dmg,sqr(dmg)):min(dmg,sqrt(dmg)); 		
				
				case DAMAGE.NORMAL:
					if dmg < 10 { return invert?clamp(dmg +.9,dmg/.25,dmg/.8):(clamp(dmg -.9,dmg*.25,dmg*.8)) } else { return dmg };				
				
				case DAMAGE.PHYSICAL:
					return invert?dmg/.25:dmg*.25;
			}
		}, 
		shield: function(dmg,typ, invert = false) { 
			switch typ {
				case DAMAGE.ENERGY:
					return invert?max(dmg,sqr(dmg)):min(dmg,sqrt(dmg)); 
			
				default:
					return dmg;

			}
		}, 
		gel: function(dmg,typ,  invert = false) { 
			switch typ {
				case DAMAGE.NORMAL:
					return invert?clamp(dmg +.9,dmg/.25,dmg/.8):(clamp(dmg -.9,dmg*.25,dmg*.8));
				
				case DAMAGE.ENERGY:
					return invert?dmg/.6:dmg*.6; 
				
				case DAMAGE.PHYSICAL:
					return dmg; 

			}			
		},		
		armor: function(dmg,typ,  invert = false) { 
			switch typ {
				case DAMAGE.PHYSICAL:
					return invert?dmg/.25:dmg*.25;
					
				case DAMAGE.NORMAL:
					return invert?dmg/.75:dmg*.75; 
				
				case DAMAGE.ENERGY:
					return dmg; 				
			}			
		},	
		base: function(dmg,typ,  invert = false) { 
			return dmg; 
		}		            
	}
    for (var i = 0; i < array_length(types); i++) {
        if variable_struct_exists(hp_struct, types[i]) {
            var hp_val = struct_get(hp_struct, types[i]);
			var mitigate = struct_get(mitigation, types[i]);
			if is_undefined(mitigate) mitigate = function(dmg,typ, invert = false) { return dmg; };
			var mitigated = mitigate(raw_damage,type);
            // Apply mitigated damage to current hp type
            var remaining = max(hp_val - mitigated, 0);
            var absorbed = hp_val - remaining;
            struct_set(hp_struct,types[i],remaining);
			if absorbed > 0 && instance_exists(object) {
				with object {
					last_damaged = 0;
				}
			}	
            // If all mitigated damage was absorbed, stop
            if absorbed >= mitigated {
                exit;
            }
			raw_damage -= mitigate(absorbed,type,true);
            // Else, move on to next HP type, but pass in the original raw_damage again
        }
    }
}