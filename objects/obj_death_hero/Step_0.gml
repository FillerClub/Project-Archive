
expire += delta_time*DELTA_TO_SECONDS/2;
if expire >= 4.5 {
	if online {
		room_goto(rm_match_menu);	
	} else {
		room_goto(rm_main_menu);	
	}
	instance_destroy();
}