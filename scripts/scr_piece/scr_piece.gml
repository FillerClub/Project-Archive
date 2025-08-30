/// @description	Run generic piece code
function piece() {
if time_source_get_state(error_time) == time_source_state_stopped {
	timer_color = c_white;
}
if time_source_get_state(invin_blink_time) == time_source_state_stopped {
	invincible_tick = 1;
}
var anim = -1;
// By default return to idle animations when done playing misc animations
if layer_sequence_exists("Instances",animation) {
	anim = layer_sequence_get_instance(animation);
	layer_sequence_xscale(animation,tm_dp(-1,team,toggle));
	layer_sequence_x(animation,x +sprite_width/2);
	layer_sequence_y(animation,y +sprite_height/2);
	if layer_sequence_is_finished(animation) {
		new_animation = default_animation;
	}
}
if global.game_state == PAUSED && !ignore_pause {
	if anim != -1 {
		anim.speedScale	= 0;
	}
	return false;
} 

if instance_exists(piece_on_grid) {
	x = grid_pos[0]*GRIDSPACE +piece_on_grid.bbox_left;
	y = grid_pos[1]*GRIDSPACE +piece_on_grid.bbox_top;
} 

depth = -bbox_bottom -z;
if ai_controlled { auto_attack_timer(); }

effect_process();
manage_health();
effect_manager_process();

return true;
}