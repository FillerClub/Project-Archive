with obj_generic_hero_OLD {
	if team == other.team {
		other.x = x;
		other.y = y;
	}
	audio_play_sound(snd_shock,0,0);
}