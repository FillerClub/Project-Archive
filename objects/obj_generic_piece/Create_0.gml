/// @desc Grabs object info from database
#macro HEALTHCOSTMULTIPLIER .6
move_cooldown = piece_database(identity,PIECEDATA.MOVECOOLDOWN);
move_cooldown_timer = move_cooldown;
hp = piece_database(identity,PIECEDATA.HP);
hp_init = hp;
hp_start = hp;
valid_moves = piece_database(identity,PIECEDATA.MOVES);
cost = piece_database(identity,PIECEDATA.MOVECOST);
sprite_index = piece_database(identity,PIECEDATA.SPRITE);
time_to_take = 1.6 + HEALTHCOSTMULTIPLIER*cost;

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