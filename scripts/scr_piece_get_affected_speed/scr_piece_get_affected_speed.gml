function piece_get_affected_speed(base = delta_time) {
	var 
	sPD = effects_array[EFFECT.SPEED],
	sLW = effects_array[EFFECT.SLOW];
	return speed_slow_formula(base*global.level_speed,sPD,sLW);
}