/// @desc Grabs object info from database
#macro HEALTHCOSTMULTIPLIER .6
speed_effect = piece_database(identity,PIECEDATA.SPDEFFECT);
slow_effect = piece_database(identity,PIECEDATA.SLWEFFECT);
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

if asset_get_type(place_sound) == asset_sound {
	audio_play_sound(place_sound,0,0);
}
