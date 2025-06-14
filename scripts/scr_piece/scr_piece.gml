/// @description	Run generic piece code
function piece() {
if time_source_get_state(error_time) == time_source_state_stopped {
	timer_color = c_black;
}
if time_source_get_state(intan_blink_time) == time_source_state_stopped {
	intangible_tick = 1;
}
if global.game_state == PAUSED && !ignore_pause {
	// Delay alarms responsible for invincibilty
	if alarm[0] > 0 {	alarm[0]++;	}
	return false;
}

if piece_on_grid != noone {
	if instance_exists(piece_on_grid) {
		x = grid_pos[0]*GRIDSPACE +piece_on_grid.bbox_left;
		y = grid_pos[1]*GRIDSPACE +piece_on_grid.bbox_top;
	} else {
		//on_grid = noone;	
	}
}

deal_with_effects();

depth = -bbox_bottom;
if ai_controlled { auto_attack_timer(); }


var 
sPD = effects_array[EFFECT.SPEED],
sLW = effects_array[EFFECT.SLOW],
pOIS = effects_array[EFFECT.POISON];

// Speed and slow effects
var timerTickRate = delta_time*DELTA_TO_SECONDS*((1 +sPD/5)/(1 +sLW/5));
// Tick internal timer
if !skip_timer { 
	timer += timerTickRate;
}
move_cooldown_timer = max(move_cooldown_timer -timerTickRate,0);

// If intangible, intiate flashing timer
if effects_array[EFFECT.INTANGIBILITY] > 0 {
	if time_source_get_state(intan_blink_time) != time_source_state_active {
		time_source_start(intan_blink_time);	
	}
	intangible = true;
} else {
	if time_source_get_state(intan_blink_time) == time_source_state_active {
		time_source_stop(intan_blink_time);	
	}
	intangible = false;
}
// Poison
if pOIS > 0 {
	poison_tick += delta_time*DELTA_TO_SECONDS;
	var poison_end_tick = 3/(1 +pOIS/5);
	if poison_tick >= poison_end_tick {
		poison_tick -= poison_end_tick;
		hp--;
	}
} else {
	poison_tick = 0; 	
}

// If it has no hp, destroy
if hp <= 0 {
	instance_destroy();	
}
if hp > hp_max {
	hp = hp_max;
	hp_init = hp_max;
}

return true;
}