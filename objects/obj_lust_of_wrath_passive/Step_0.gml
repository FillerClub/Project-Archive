var Hi = 0,
Pi = 0,
buffIncrease = 0;
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
		if total_health(hp) <= 0 && wrath_ability_activate == false { 
			wrath_ability_activate = true;
		} else if total_health(hp) > 0 {
			wrath_ability_activate = false;
		}
		if wrath_ability_activate {
			buffIncrease++;
		}
	}
}
var createSpeed = 1 +(buffIncrease/(global.barrier_criteria -1));

with obj_piece_slot {
	// ONLY buff piece slots
	if object_index == obj_piece_slot && team == other.team {
		speed_factor = createSpeed;
	}
}