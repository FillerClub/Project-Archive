/// @desc Grabs object info from database
#macro HEALTHCOSTMULTIPLIER .6
speed_effect = refer_database(identity,SPDEFFECT);
slow_effect = refer_database(identity,SLWEFFECT);
hp = refer_database(identity,HP);
hp_init = hp;
hp_start = hp;
valid_moves = refer_database(identity,MOVES);
cost = refer_database(identity,MOVECOST);
sprite_index = refer_database(identity,SPRITE);
time_to_take = 1.6 + HEALTHCOSTMULTIPLIER*cost;


if asset_get_type(place_sound) == asset_sound {
	audio_play_sound(place_sound,0,0);
}
