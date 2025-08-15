error_time = time_source_create(time_source_global,.03,time_source_units_seconds,function(){
	if draw_red_box == 0 {
		draw_red_box = 1;
	} else {
		draw_red_box = 0;
	}	
},[],6);

info = piece_database(identity);

sprite_slot = info[$ "slot_sprite"];
cost = info[$ "place_cost"];
class = info[$ "class"];
desc = info[$ "short_description"];
cooldown_length = info[$ "slot_cooldown"];
cooldown = 0;
with obj_generic_hero {
	if team != other.team {
		continue;
	}
	var classes = hero_database(identity,HERODATA.CLASSES),
	matchingClass = false;
	for (var i = 0; i < array_length(classes); i++) {
		if classes[i] == other.class {
			matchingClass = true;
			break;
		}
	}
	if !matchingClass {
		other.cooldown_length = other.cooldown_length*2;
		other.cooldown = other.cooldown_length;
	}
}
