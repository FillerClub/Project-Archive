function enemy_spawn_sequence(start_phase,spawn_identity,time_per_spawn = 7, spawn_amount = 1,spawn_x_offset = 0,spawn_y_offset = 0){
	var 
	gD = global.grid_dimensions,
	gS = global.grid_spacing;
	if !(phase >= start_phase) || !(phase < start_phase +1) || timer < time_per_spawn {
		exit;	
	}
	//Check if piece can be spawned
	if position_meeting(gD[1] -abs(spawn_x_offset*gS),gD[2] +spawn_y_offset*gS,obj_obstacle) {
		// Delay so "AI" can try spawning a piece again
		timer = time_per_spawn -.7;
		exit;
	}
	var spawnArrayLength = array_length(spawn_identity) -1,
	spawnActual = spawn_identity[irandom_range(0,spawnArrayLength)],
	obj = piece_database(spawnActual,PIECEDATA.OBJECT);
	//Increment
	phase = clamp(phase +1/spawn_amount,start_phase,start_phase+1);
	timer -= time_per_spawn;
	instance_create_layer(gD[1] -abs(spawn_x_offset*gS),gD[2] +spawn_y_offset*gS,"Instances",obj,{
		identity: spawnActual,
		team: "enemy",
		ai_controlled: true
	});
	if phase >= start_phase +1 {
		return true;	
	}
}