function delete_team(target_team){
with obj_generic_hero {
	if team == target_team {
		instance_destroy();
	}
}
with obj_timer {
	if team == target_team {
		x += 6000;
	}
}
with obj_profile {
	if team == target_team {
		instance_destroy();	
	}
}	
with obj_hero_wall {
	if team == target_team {
		instance_destroy();	
	}
}	
with obj_grid {
	if team == target_team {
		generate_walls = false;
	}
}	
with obj_power_slot {
	if team == target_team {
		instance_destroy();	
	}
}	
with obj_power_passive {
	if team == target_team {
		instance_destroy();	
	}
}
}