function auto_attack_timer() {
if ai_timer >= time_to_take {
	ai_timer = time_to_take;	
}

if skip_timer {
	timer = 0;
} else {
	ai_timer = 0;	
}

skip_timer = false;
}