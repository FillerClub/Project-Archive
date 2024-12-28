audio_stop_sound(snd);





var gS = GRIDSPACE;
var gD = global.grid_dimensions;

var sound_params = {
	sound: snd_explosion,
	pitch: random_range(0.9,1.1),
	};

var ar_leng = array_length(valid_moves);

audio_play_sound_ext(sound_params);

for (var i = 0; i < ar_leng; ++i) {
	
	if place_meeting(valid_moves[i][0],valid_moves[i][1],obj_grid) {
		repeat(20){
			part_particles_burst(global.part_sys,valid_moves[i][0] +gS/2,valid_moves[i][1] +gS/2,part_explode);		
		}
		if place_meeting(valid_moves[i][0],valid_moves[i][1],obj_generic_piece) {
			with instance_place(valid_moves[i][0],valid_moves[i][1],obj_generic_piece) {
				if !intangible {
					hp -= 5;
				}
			}
		}
	}
}