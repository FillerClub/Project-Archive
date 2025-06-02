function create_piece_from_slot(create) {
if !create {
	exit;	
}

var 
i = 0,
gS = GRIDSPACE,
selectthis = true,
gX = obj_cursor.x,
gY = obj_cursor.y,
mosX = floor(gX/gS)*gS,
mosY = floor(gY/gS)*gS;

with obj_generic_piece {
	if team == global.player_team && object_get_parent(object_index) != obj_generic_hero_OLD {
		i++;	
	}
}

if i < global.max_pawns {
	if ((global.player_team == "friendly")? (global.player_turns >= cost):(global.opponent_turns >= cost)) {
		switch object_index {
			case obj_piece_slot:
				var info = piece_database(identity);
				instance_create_layer(gX,gY,"AboveBoard",obj_dummy, {
					object: info[PIECEDATA.OBJECT],	
					sprite_index: info[PIECEDATA.SPRITE],
					turn_cost: cost,
					team: global.player_team,
					on_grid: info[PIECEDATA.PLACEMENTONGRID],
					on_piece: info[PIECEDATA.PLACEMENTONPIECE],
					identity: identity, 
					orig_x: x, 
					orig_y: y,	
					link: id,
				});
			break;
			case obj_power_slot:
			var info = power_database(name);
				instance_create_layer(gX,gY,"AboveBoard",obj_dummy, {
					object: info[POWERDATA.OBJECT],
					sprite_index: info[POWERDATA.SLOTSPRITE],
					turn_cost: cost,
					team: global.player_team,
					on_grid: info[POWERDATA.PLACEMENTONGRID],
					on_piece: info[POWERDATA.PLACEMENTONPIECE],
					identity: identity, 
					orig_x: x, 
					orig_y: y,	
					link: id,
				});			
			break;
		}

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
	
if ((global.player_team == "friendly")? (global.player_turns < cost):(global.opponent_turns < cost)) {
	audio_stop_sound(snd_pick_up);
	audio_stop_sound(snd_error);
	audio_stop_sound(snd_critical_error);
	audio_play_sound(snd_critical_error,0,0);	
	with obj_timer {
		if team == global.player_team {
			scr_error();
		}
	}
	with obj_turn_operator {
		if team == global.player_team {
			scr_error();
		}
	}	
}
}