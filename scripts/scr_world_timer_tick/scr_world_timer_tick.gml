
function world_timer_tick(reverse = false){
	var enemyPiecePresent = false;
	with obj_generic_piece {
		if team == global.enemy_team {
			enemyPiecePresent = true;
		} 
	}
	var timerAccel = ((!enemyPiecePresent && phase >= 1))/1.5,
	rev = 1;

	if reverse {
		rev = -1;
	}
	timer += delta_time*DELTA_TO_SECONDS*(1 +timerAccel)*timer_mod*rev;	
}