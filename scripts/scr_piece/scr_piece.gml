/// @description	Run generic piece code
function piece() {
if time_source_get_state(error_time) == time_source_state_stopped {
	timer_color = c_black;
}
if time_source_get_state(intan_blink_time) == time_source_state_stopped {
	intangible_tick = 1;
}
if global.pause && !ignore_pause {
	// Delay alarms responsible for invincibilty
	if alarm[0] > 0 {	alarm[0]++;	}
	return false;
}

deal_with_effects();

moved = false;
depth = -bbox_bottom;
if ai_controlled { auto_attack_timer(); }


var 
gS = global.grid_spacing,
gD = global.grid_dimensions,
gClampX = clamp(floor(x),gD[0],gD[1]),
gClampY = clamp(floor(y),gD[2],gD[3]),
sPD = effects_array[EFFECT.SPEED],
sLW = effects_array[EFFECT.SLOW];

var timerTickRate = (delta_time*DELTA_TO_SECONDS*(1 +sPD/5))/(1 +sLW/5);
// Tick internal timer
if !skip_timer { 
	timer += timerTickRate;
}
move_cooldown_timer = min(move_cooldown_timer +timerTickRate,move_cooldown);
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

// if it is in an illegal area, destroy
if !place_meeting(x,y,obj_grid) || place_meeting(gClampX,gClampY,obj_obstacle) { 
	instance_destroy();
}
// If it has no hp, destroy
if hp <= 0 {
	instance_destroy();	
}
// If it is enemy piece, exit any execution mode
if team != global.team {
	execute = "nothing";
}	
x = gClampX
y = gClampY;
return true;
}