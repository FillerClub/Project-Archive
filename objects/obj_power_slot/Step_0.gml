var create = false,
gS = GRIDSPACE,
selectthis = true,
gX = obj_cursor.x,
gY = obj_cursor.y,
mosX = floor(gX/gS)*gS,
mosY = floor(gY/gS)*gS;

if time_source_get_state(error_time) == time_source_state_stopped {
	draw_red_box = 0;
}
if global.game_state == PAUSED {
	exit;	
}
if cooldown > 0 && !pause_cooldown {
	cooldown -= delta_time*DELTA_TO_SECONDS;
}
if skip || global.mode == "delete" || global.player_team != team {
	skip = false;
	exit;	
}

// On Click
if position_meeting(gX,gY,self) && input_check_pressed("action") {
	if cooldown <= 0 && !instance_exists(obj_dummy) {
		select_sound(snd_pick_up);
		create = true;
	} else if cooldown > 0 {
		scr_error();	
		audio_stop_sound(snd_critical_error);
		audio_play_sound(snd_critical_error,0,0);	
	}
}

create_piece_from_slot(create);