audio_stop_all();
audio_play_sound(snd_game_end,0,0);
part_particles_clear(global.part_sys);

instance_create_layer(x,y,"Instances",obj_death_hero, {
	sprite_index: sprite_index,
	x: x,
	y: y,
	team: team
});

room_goto(rm_gameover);

