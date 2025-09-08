var create = false,
gS = GRIDSPACE,
selectthis = true,
gX = obj_cursor.x,
gY = obj_cursor.y,
paused = global.game_state,
mosX = floor(gX/gS)*gS,
mosY = floor(gY/gS)*gS;

if time_source_get_state(error_time) == time_source_state_stopped {
	draw_red_box = 0;
}
if cooldown > 0 && paused != PAUSED {
	cooldown -= delta_time*DELTA_TO_SECONDS*global.level_speed*speed_factor;
}
if paused == PAUSED || skip || global.mode == "delete" || team == global.opponent_team {
	skip = false;
	exit;	
}
// On Click
if position_meeting(gX,gY,self) && input_check_pressed("action") && identity != "Empty" {	
	if !instance_exists(obj_dummy) {
		select_sound(snd_pick_up);
		create = true;
	}
}

create_piece_from_slot(create);

if highlight {
	timer += delta_time*DELTA_TO_SECONDS*5*global.level_speed;
	highlight_alpha = (sin(timer) +1)/2;
	if timer >= 4*pi {
		timer = 0;
	}
} else {
	highlight_alpha = 0;
}