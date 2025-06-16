
function world_timer_tick(reverse = false){
	var enemyPiecePresent = false;
	with obj_generic_piece {
		if team == global.opponent_team {
			enemyPiecePresent = true;
		} 
	}
	var countFPiece = 0;
	with obj_generic_piece {
		if team == global.player_team {
			countFPiece++;
		}
	}
	var timerAbsentAccel = (1 +((!enemyPiecePresent && phase >= 1))/1.5),
	timerCatchupAccel = (1 +countFPiece/20),
	timerHeroProgression = (1 +hero_phase/8),
	rev = 1;

	if reverse {
		rev = -1;
	}

	var totalFact = rev*timer_mod*timerAbsentAccel*timerCatchupAccel*timerHeroProgression;
	/*
	instance_create_layer(room_width/2,room_height/2,"GUI",obj_hit_fx, {
		hp: totalFact,
		x_target: room_width/2,
		y_target: room_height/2,
		diff_factor: 1
	});
	*/
	timer += delta_time*DELTA_TO_SECONDS*totalFact*global.level_speed;	
	
}