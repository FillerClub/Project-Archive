/// @desc Grabs object info from database
// Set on grid if pos nor grid not set for piece
if piece_on_grid == noone && position_meeting(x,y,obj_grid) {
	piece_on_grid = instance_position(x,y,obj_grid);
}
if grid_pos[0] == -1 && grid_pos[1] == -1 && piece_on_grid != noone {
	grid_pos[0] = floor((x -piece_on_grid.bbox_left)/GRIDSPACE);
	grid_pos[1] = floor((y -piece_on_grid.bbox_top)/GRIDSPACE); 
}
if instance_exists(piece_on_grid) {
	x = grid_pos[0]*GRIDSPACE +piece_on_grid.bbox_left;
	y = grid_pos[1]*GRIDSPACE +piece_on_grid.bbox_top;
}
data = piece_database(identity);
hp = data[$ "hp"];
hp_max = variable_clone(data[$ "hp"]);
last_damaged = infinity;

move_cooldown_timer = 0;
move_cooldown = data[$ "move_cooldown"];
attack_power = data[$ "attack_power"];

valid_moves = data[$ "moves"];
cost = data[$ "move_cost"];
sprite_index = data[$ "sprite"];

error_time = time_source_create(time_source_global,.03,time_source_units_seconds,function(){
	if timer_color == c_black {
		timer_color = c_red;
	} else {
		timer_color = c_black;
	}			
},[],6);

invin_blink_time = time_source_create(time_source_global,.03,time_source_units_seconds,function(){
	if invincible_tick == 1 {
		invincible_tick = .5;
	} else {
		invincible_tick = 1;
	}			
},[],-1);

if asset_get_type(place_sound) == asset_sound {
	audio_stop_sound(place_sound);
	audio_play_sound(place_sound,0,0);
}



effects_management_array[0] = new effect_array_create(EFFECT.NOTHING,"Base");
effects_array = array_create(EFFECT.FIRE +1,0);
