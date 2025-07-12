var Hi = 0,
Pi = 0,
buffIncreased = false;
with obj_hero_wall {
	if team != other.team {
		other.wall_tracking_array[Hi] = id;
		if !variable_instance_exists(self,"wrath_ability_activate") {
			wrath_ability_activate = false;
		}
		Hi++;
	}
}

for (var ii = 0; ii < array_length(wall_tracking_array);ii++) {
	with wall_tracking_array[ii] {
		if hp <= 0 && wrath_ability_activate == false {
			// Avoid buffing in the same frame 
			if !buffIncreased {
				wrath_ability_activate = true;
				buffIncreased = true;
			}
		}
	}
}

with obj_generic_piece {
	if team == other.team {
		other.piece_tracking_array[Pi] = id;
		if buffIncreased && variable_instance_exists(self,"wrath_passive_buffed") {
			if wrath_passive_buffed {
				// Cancels out previous buffs given
				effects_array[EFFECT.SPEED] -= other.passive_buff;
			}
		}
		
		if buffIncreased || !variable_instance_exists(self,"wrath_passive_buffed") {
			wrath_passive_buffed = false;
		}
		Pi++;
	}
}

if buffIncreased {
	passive_buff++;	
}

for (var iii = 0; iii < array_length(piece_tracking_array);iii++) {
	with piece_tracking_array[iii] {
		if wrath_passive_buffed == false {
			effect_generate(EFFECT.SPEED,infinity,"empress_lust",other.passive_buff);
			wrath_passive_buffed = true;
		}
	}	
}