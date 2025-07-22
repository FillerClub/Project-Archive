/// @description	Run generic piece code
function piece() {
if time_source_get_state(error_time) == time_source_state_stopped {
	timer_color = c_black;
}
if time_source_get_state(invin_blink_time) == time_source_state_stopped {
	invincible_tick = 1;
}
if global.game_state == PAUSED && !ignore_pause {
	// Delay alarms responsible for invincibilty
	if alarm[0] > 0 {	alarm[0]++;	}
	return false;
}

if instance_exists(piece_on_grid) {
	x = grid_pos[0]*GRIDSPACE +piece_on_grid.bbox_left;
	y = grid_pos[1]*GRIDSPACE +piece_on_grid.bbox_top;
	z = piece_on_grid.z;
} 

depth = -bbox_bottom +z;
if ai_controlled { auto_attack_timer(); }


var 
sPD = effects_array[EFFECT.SPEED],
sLW = effects_array[EFFECT.SLOW],
pOIS = effects_array[EFFECT.POISON];

// Speed and slow effects
var
timerTickRate = delta_time*DELTA_TO_SECONDS*global.level_speed,
effectModifier = (1 +sPD/5)/(1 +sLW/5);
// Tick internal timer
if !skip_timer { 
	// Effect timer is used to time buffs/debuffs, not affected by speed or slow
	effects_timer += timerTickRate;
	// Base timer is affected by speed and slow
	timer += timerTickRate*effectModifier;
}
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
if pOIS > 0 {
	poison_tick += delta_time*DELTA_TO_SECONDS*global.level_speed;
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
deal_with_effects();
return true;
}