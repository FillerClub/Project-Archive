valid_moves = [	[x,y],
				[x +GRIDSPACE,y +GRIDSPACE],
				[x -GRIDSPACE,y +GRIDSPACE],
				[x +GRIDSPACE,y -GRIDSPACE],
				[x -GRIDSPACE,y -GRIDSPACE],
				[x,y +GRIDSPACE],
				[x,y -GRIDSPACE],
				[x +GRIDSPACE,y],
				[x -GRIDSPACE,y],];

var sound_params = {
	sound: snd_warning,
	loop: true,
	};

snd = audio_play_sound_ext(sound_params);