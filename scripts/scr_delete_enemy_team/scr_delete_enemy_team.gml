// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
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