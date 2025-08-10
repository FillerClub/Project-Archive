/// @description	Run generic piece code
function piece() {
if time_source_get_state(error_time) == time_source_state_stopped {
	timer_color = c_black;
}
if time_source_get_state(invin_blink_time) == time_source_state_stopped {
	invincible_tick = 1;
}
if global.game_state == PAUSED && !ignore_pause {
	return false;
}

if instance_exists(piece_on_grid) {
	x = grid_pos[0]*GRIDSPACE +piece_on_grid.bbox_left;
	y = grid_pos[1]*GRIDSPACE +piece_on_grid.bbox_top;
} 

depth = -bbox_bottom +z;
if ai_controlled { auto_attack_timer(); }

effect_process();
manage_health();
effect_manager_process();
return true;
}