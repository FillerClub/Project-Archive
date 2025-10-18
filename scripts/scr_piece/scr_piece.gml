/// @description	Run generic piece code
function base_piece_behavior() {
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
	if layer_sequence_is_finished(animation) {
		new_animation = default_animation;
		interpolation_speed = default_interpolation_speed;
	}
	if starting_sequence_pos != -1 {
		new_animation = asset_get_index(starting_sequence);
	}
	layer_sequence_xscale(animation,tm_dp(anim_scale,team,toggle));
	layer_sequence_x(animation,x +sprite_width/2);
	layer_sequence_y(animation,y +sprite_height/2);
}
if global.game_state == PAUSED && !ignore_pause {
	if anim != -1 {
		anim.speedScale	= 0;
	}
	return false;
} 
interpolation_lerp = clamp(interpolation_lerp +delta_time*DELTA_TO_SECONDS*global.level_speed/interpolation_speed,0,1);

var gridRef = piece_on_grid;
if is_string(gridRef) {
	with obj_grid {
		if tag == gridRef {
			other.x = other.grid_pos[0]*GRIDSPACE +bbox_left;
			other.y = other.grid_pos[1]*GRIDSPACE +bbox_top;		
		}
	}
} else if instance_exists(gridRef) {
	x = grid_pos[0]*GRIDSPACE +gridRef.bbox_left;
	y = grid_pos[1]*GRIDSPACE +gridRef.bbox_top;
} 

depth = -bbox_bottom -z;
if ai_controlled { auto_attack_timer(); }

effect_process();
manage_health();
effect_manager_process();

return true;
}