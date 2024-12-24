var i = 0;
with obj_hero_wall {
	if team == other.team {
		other.wall_tracking_array[i] = id;
		if !variable_instance_exists(self,"aegis_ability_done") {
			aegis_ability_done = false;
		}
		i++;
	}
}

for (var ii = 0; ii < array_length(wall_tracking_array);ii++) {
	with wall_tracking_array[ii] {
		if hp <= 0 && aegis_ability_done == false {
			instance_create_layer(x,y,"Instances",obj_aegis_bloom_power,{
				team: team
			});	
			aegis_ability_done = true;
		}
	}
}