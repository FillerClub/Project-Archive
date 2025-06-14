/// @desc Grabs object info from database

// Set on grid if pos nor grid not set for piece
if piece_on_grid == noone && position_meeting(x,y,obj_grid) {
	piece_on_grid = instance_position(x,y,obj_grid);
}
if grid_pos[0] == -1 && grid_pos[1] == -1 && piece_on_grid != noone {
	grid_pos[0] = floor((x -piece_on_grid.bbox_left)/GRIDSPACE);
	grid_pos[1] = floor((y -piece_on_grid.bbox_top)/GRIDSPACE); 
}
move_cooldown_timer = 0;
move_cooldown = piece_database(identity,PIECEDATA.MOVECOOLDOWN);
hp = piece_database(identity,PIECEDATA.HP);
attack_power = piece_database(identity,PIECEDATA.ATTACKPOWER);
hp_init = hp;
hp_max = hp;
valid_moves = piece_database(identity,PIECEDATA.MOVES);
cost = piece_database(identity,PIECEDATA.MOVECOST);
sprite_index = piece_database(identity,PIECEDATA.SPRITE);

error_time = time_source_create(time_source_global,.03,time_source_units_seconds,function(){
	if timer_color == c_black {
		timer_color = c_red;
	} else {
		timer_color = c_black;
	}			
},[],6);

intan_blink_time = time_source_create(time_source_global,.03,time_source_units_seconds,function(){
	if intangible_tick == 1 {
		intangible_tick = .5;
	} else {
		intangible_tick = 1;
	}			
},[],-1);

if asset_get_type(place_sound) == asset_sound {
	audio_stop_sound(place_sound);
	audio_play_sound(place_sound,0,0);
}



effects_management_array[0] = new effect_add(EFFECT.NOTHING);
effects_array[EFFECT.SPEED] = 0;
effects_array[EFFECT.SLOW] = 0;
effects_array[EFFECT.INTANGIBILITY] = 0;
effects_array[EFFECT.POISON] = 0;