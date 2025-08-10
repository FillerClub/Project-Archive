var own = noone;
with obj_constant_reload {
	if team == other.team {
		own = self;	
	}
}
if !instance_exists(own) {
	instance_destroy();
	exit;
}
if own.ammo <= 0 {
	instance_destroy();	
}
timer += delta_time*DELTA_TO_SECONDS*global.level_speed;

if timer >= .15 {
	own.ammo--;
	audio_play_sound(snd_final_bullet,0,0);
	timer = 0;
}