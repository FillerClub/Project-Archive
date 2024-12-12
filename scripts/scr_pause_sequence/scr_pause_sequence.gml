function pause_sequence(start_phase,execute_time_passing,time_to_pass = 7) {
	if (phase >= start_phase) && (phase < start_phase +1) {
		if !execute_time_passing {
			timer[MAIN] = 0;	
		} else if (timer[MAIN] >= time_to_pass) {
			//Increment
			timer[MAIN] = 0;
			phase = min(phase +1,start_phase +1);
			if phase >= start_phase +1 {
				return true;	
			}
		}
	}
}