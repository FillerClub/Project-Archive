function enemy_spawn_sequence(start_phase,spawn_identity,time_per_spawn = 7, spawn_amount = 1,spawn_x_offset = 0,spawn_y_offset = 0){
	var 
	gD = global.grid_dimensions,
	gS = GRIDSPACE,
	spawnArrayLength = array_length(spawn_identity) -1,
	spawnActual = spawn_identity[irandom_range(0,spawnArrayLength)];
	
	if !(phase >= start_phase) || !(phase < start_phase +1) || timer < time_per_spawn {
		exit;	
	}
	//Check if piece can be spawned
	if (position_meeting(gD[1] -abs(spawn_x_offset*gS),gD[2] +spawn_y_offset*gS,obj_obstacle)) {
		// Delay so "AI" can try spawning a piece again
		timer = time_per_spawn -.1;
		exit;
	}

	//Increment
	phase = clamp(phase +1/spawn_amount,start_phase,start_phase+1);
	timer -= time_per_spawn;
	
	ai_spawn(spawn_x_offset,spawn_y_offset,spawnActual);
	if phase >= start_phase +1 {
		return true;	
	}
}