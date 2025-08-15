var sound_params = {
sound: sound,
pitch: random_range(0.7,1.3),
};
repeat(30){ part_particles_burst(global.part_sys,x,y -z,part_bullet_impact); }	
audio_play_sound_ext(sound_params);

if variable_instance_exists(self,"on_destroy") {
	on_destroy();	
}