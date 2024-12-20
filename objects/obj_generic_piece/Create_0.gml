/// @desc Grabs object info from database
#macro HEALTHCOSTMULTIPLIER .6
speed_effect = refer_database(identity,SPDEFFECT);
slow_effect = refer_database(identity,SLWEFFECT);
move_cooldown = refer_database(identity,MOVECOOLDOWN);
move_cooldown_timer = move_cooldown;
hp = refer_database(identity,HP);
hp_init = hp;
hp_start = hp;
valid_moves = refer_database(identity,MOVES);
cost = refer_database(identity,MOVECOST);
sprite_index = refer_database(identity,SPRITE);
time_to_take = 1.6 + HEALTHCOSTMULTIPLIER*cost;
error_time = time_source_create(time_source_global,.03,time_source_units_seconds,function(){
	if timer_color == c_black {
		timer_color = c_red;
	} else {
		timer_color = c_black;
	}			
},[],10);

if asset_get_type(place_sound) == asset_sound {
	audio_play_sound(place_sound,0,0);
}
