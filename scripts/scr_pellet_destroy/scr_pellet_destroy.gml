function scr_pellet_destroy() {
var oth = other;

if oth.team != team && !oth.intangible {
	var sound_params = {
	sound: snd_bullet_hit,
	pitch: random_range(0.7,1.3),
	};
			
	audio_play_sound_ext(sound_params);
	oth.hp -= dmg;			
	repeat(30){ part_particles_burst(global.part_sys,x,y,part_bullet_impact); }
			
	instance_destroy();
}
}