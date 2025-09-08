function effect_process() {
	var 
	sPD = effects_array[EFFECT.SPEED],
	sLW = effects_array[EFFECT.SLOW],
	pOIS = effects_array[EFFECT.POISON],
	fIRE = effects_array[EFFECT.FIRE],
	oH = effects_array[EFFECT.OVERHEALTH],
	totalDOT = pOIS +fIRE*10;

	// Speed and slow effects
	var
	baseRate = delta_time*DELTA_TO_SECONDS,
	levelSpd = global.level_speed,
	timerTickRate = baseRate*levelSpd,
	effectModifier = speed_slow_formula(1,sPD,sLW);
	last_damaged += baseRate;
	// Tick internal timer
	// Effect timer is used to time buffs/debuffs, not affected by speed or slow
	effects_timer += timerTickRate;
	if !skip_timer && uses_timer { 
		// Base timer is affected by speed and slow
		timer += timerTickRate*effectModifier;
	}
	// Animation speed 
	if layer_sequence_exists("Instances",animation) {
		var anim = layer_sequence_get_instance(animation);
		anim.speedScale = levelSpd*effectModifier;	
	}
	blink_timer += timerTickRate;
	if blink_timer >= blink_end {
		var blinkDuration = blink_timer -blink_end;
		eye_scale_fact = abs(cos(pi*blinkDuration/BLINKTIME));
	} else {
		eye_scale_fact = 1;
	}	
	if blink_timer >= blink_end +BLINKTIME {
		blink_timer -= blink_end +BLINKTIME;
		blink_end = random_range(1,5);
	}
	// Movement timer
	move_cooldown_timer = max(move_cooldown_timer -timerTickRate*effectModifier,0);	
	
	// If invincible, intiate flashing timer
	if effects_array[EFFECT.INVINCIBILITY] > 0 {
		if time_source_get_state(invin_blink_time) != time_source_state_active {
			time_source_start(invin_blink_time);	
		}
		invincible = true;
	} else {
		if time_source_get_state(invin_blink_time) == time_source_state_active {
			time_source_stop(invin_blink_time);	
		}
		invincible = false;
	}
	// Poison
	if totalDOT > 0 {
		poison_tick += timerTickRate;
		var end_tick = 3/(1 +totalDOT/5);
		if poison_tick >= end_tick {
			poison_tick -= end_tick;
			hp.base--;
			last_damaged = 0;
		}
	} else {
		poison_tick = 0; 	
	}
	// Overhealth
	if variable_struct_exists(hp_max,"over") {
		hp_max.over = oH;	
	}
}