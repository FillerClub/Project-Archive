function auto_attack_timer() {
if ai_timer >= TIMETOTAKE {
	ai_timer = TIMETOTAKE;	
}

if skip_timer {
	timer = 0;
} else {
	ai_timer = 0;	
}

skip_timer = false;
}