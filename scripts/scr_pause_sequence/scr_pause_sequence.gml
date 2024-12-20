function pause_sequence(start_phase,execute_time_passing,time_to_pass = 7) {
	if !(phase >= start_phase) || !(phase < start_phase +1) {
		exit;
	}
	
	if execute_time_passing && timer >= time_to_pass {
		//Increment
		phase++;
		timer -= time_to_pass;
		if phase >= start_phase +1 {
			return true;	
		}
	} else if !execute_time_passing {
		timer = 0;	
	}
}