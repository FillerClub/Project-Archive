var create = false,
gS = GRIDSPACE,
selectthis = true,
gX = obj_cursor.x,
gY = obj_cursor.y,
mosX = floor(gX/gS)*gS,
mosY = floor(gY/gS)*gS,
her = noone;

if time_source_get_state(error_time) == time_source_state_stopped {
	draw_red_box = 0;
}
if global.game_state == PAUSED {
	exit;	
}
if cooldown > 0 && !pause_cooldown {
	cooldown -= delta_time*DELTA_TO_SECONDS*global.level_speed;
} else if cooldown < 0 {
	cooldown = 0;	
}
if skip || global.mode == "delete" || global.player_team != team {
	skip = false;
	exit;	
}
with obj_generic_hero {
	if team == other.team {
		her = self;	
	}
}
// On Click
if position_meeting(gX,gY,self) && input_check_pressed("action") {
	if cooldown <= 0 && !instance_exists(obj_dummy) {
		create = true;
	} else if cooldown > 0 {
		scr_error();	
		audio_stop_sound(snd_critical_error);
		audio_play_sound(snd_critical_error,0,0);	
		exit;
	}
	if !special_slot_checks() {
		create = false;
	}
}

create_piece_from_slot(create);