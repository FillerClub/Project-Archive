
if total_health(hp) <= 0 && !destroyed {
	destroyed = true;
	invincible = true;
	audio_play_sound(snd_delete,0,0);
}

if destroyed {
	image_angle += rotation_speed*delta_time*DELTA_TO_SECONDS*global.level_speed;
	x += x_inc*delta_time*DELTA_TO_FRAMES;	
	y_init += y_inc;
	
	y += y_spd*delta_time*DELTA_TO_FRAMES;

	if y > y_init {
		y_spd_max = y_spd_max/degrade;
		y_spd = min(y_spd_max,-y_spd/degrade);
		rotation_speed /= degrade/1.8
		bounces++;
		if bounces > 3 {
			degrade += .25;
		}
	} else { y_spd += .05*delta_time*DELTA_TO_FRAMES; }

	if bounces > 3 {
		rotation_speed /= 1.25;
		x_inc = x_inc/1.25;
		y_inc = y_inc/1.25;
		death_timer += delta_time*DELTA_TO_SECONDS*global.level_speed;
	}
	
	if death_timer >= 2 {
		instance_destroy();	
	}
}
