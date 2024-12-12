function enemy_spawn_sequence(start_phase,spawn_identity,time_to_spawn = 7, spawn_amount = 1,spawn_x_offset = 0,spawn_y_offset = 0){
	if (timer[MAIN] >= time_to_spawn) && (phase >= start_phase) && (phase < start_phase +1) {
		var 
		gD = global.grid_dimensions,
		gS = global.grid_spacing;
		//Spawn piece
		if position_meeting(gD[1] -abs(spawn_x_offset*gS),gD[2] +spawn_y_offset*gS,obj_obstacle) {
			timer[MAIN] -= .7;
			exit;
		}
		var spawnArrayLength = array_length(spawn_identity) -1,
		spawnActual = spawn_identity[irandom_range(0,spawnArrayLength)],
		obj = refer_database(spawnActual,OBJECT);
		//Increment
		timer[MAIN] = 0;
		phase = min(phase +1/spawn_amount,start_phase +1);
		
		instance_create_layer(gD[1] -abs(spawn_x_offset*gS),gD[2] +spawn_y_offset*gS,"Instances",obj,{
			identity: spawnActual,
			team: "enemy",
			ai_controlled: true
		});
		
		if phase >= start_phase +1 {
			return true;	
		}
	}
}