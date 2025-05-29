draw_mute_red_green = clamp(draw_mute_red_green -.02,0,1);
with obj_turn_operator {
	if team == other.team {
		draw_mute_red_green = other.draw_mute_red_green;	
	}
}

if time_source_get_state(error_time) == time_source_state_stopped {
	draw_blue_green = 1;
}
	
if global.game_state == PAUSED {
	if alarm[1] > 0 { alarm[1] += 1; } 
	exit;	
}

if !instance_exists(obj_server) {
	timer += delta_time*DELTA_TO_SECONDS*global.timer_speed_mult*(1 +spd/16 -slw/16)*(accel);
	//accel += delta_time*DELTA_TO_SECONDS/1000;
}

if timer >= click_time {
	click_time += (seconds_per_turn / 16);
	if team == global.team {
		audio_play_sound(snd_timer_click,0,0);
	}
}

if (timer >= seconds_per_turn) {
	timer -= seconds_per_turn;	
	total_ticks += 1;
	click_time = seconds_per_turn / 16;
	timer_tick();
}

/*
if total_ticks >= 5 {
	total_ticks = 0;
	global.max_turns += 1;
	audio_play_sound(snd_bullet_hit,0,0);
}