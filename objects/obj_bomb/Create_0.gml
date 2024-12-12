var gS = global.grid_spacing;
var gD = global.grid_dimensions;

valid_moves = [	[x,y],
				[x +gS,y +gS],
				[x -gS,y +gS],
				[x +gS,y -gS],
				[x -gS,y -gS],
				[x,y +gS],
				[x,y -gS],
				[x +gS,y],
				[x -gS,y],];

var sound_params = {
	sound: snd_warning,
	loop: true,
	};

snd = audio_play_sound_ext(sound_params);