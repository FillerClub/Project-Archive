var create = false,
gS = global.grid_spacing,
selectthis = true,
gX = obj_cursor.x,
gY = obj_cursor.y,
mosX = floor(gX/gS)*gS,
mosY = floor(gY/gS)*gS;

if time_source_get_state(error_time) == time_source_state_stopped {
	draw_red_box = 0;
}

if global.pause || skip || global.mode == "delete" {
	skip = false;
	exit;	
}
if cooldown < cooldown_length {
	cooldown += delta_time*DELTA_TO_SECONDS;
} else {
	cooldown = cooldown_length;	
}

var i = 0;

with obj_generic_piece {
	if team == global.team && object_get_parent(object_index) != obj_generic_hero_OLD {
		i++;	
	}
}

// On Click
if position_meeting(gX,gY,self) && input_check_pressed("action") {
	if cooldown >= cooldown_length {
		if !instance_exists(obj_dummy) {
			select_sound(snd_pick_up);
			create = true;
		}
	} else {
		scr_error();	
		audio_stop_sound(snd_critical_error);
		audio_play_sound(snd_critical_error,0,0);
	}
}

if create {
	if i < global.max_pawns {
		if ((global.team == "friendly")? (global.turns >= cost):(global.enemy_turns >= cost)) {
			instance_create_layer(gX,gY,"AboveBoard",obj_dummy, {
				obj_piece: info[OBJECT],	
				sprite_index: info[SPRITE],
				turn_cost: cost,
				team: global.team,
				on_grid: info[PLACEMENTONGRID],
				on_piece: info[PLACEMENTONPIECE],
				identity: identity, 
				orig_x: x, 
				orig_y: y,	
				link: id,
			});
		}
	}
	// errors
	if i >= global.max_pawns {
		audio_stop_sound(snd_pick_up);
		audio_stop_sound(snd_error);
		audio_stop_sound(snd_critical_error);
		audio_play_sound(snd_critical_error,0,0);
		with obj_pawn_limit {
			scr_error();
		}	
	}
	
	if ((global.team == "friendly")? (global.turns < cost):(global.enemy_turns < cost)) {
		audio_stop_sound(snd_pick_up);
		audio_stop_sound(snd_error);
		audio_stop_sound(snd_critical_error);
		audio_play_sound(snd_critical_error,0,0);	
		with obj_timer {
			if team == global.team {
				scr_error();
			}
		}
		with obj_turn_operator {
			if team == global.team {
				scr_error();
			}
		}		
	}
	
}

if highlight {
	timer += delta_time*DELTA_TO_SECONDS*5;
	highlight_alpha = (sin(timer) +1)/2;
	if timer >= 4*pi {
		timer = 0;
	}
} else {
	highlight_alpha = 0;
}