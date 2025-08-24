function create_piece_from_slot(create) {
if !create {
	exit;	
}
select_sound(snd_pick_up);
var 
i = 0,
gS = GRIDSPACE,
selectthis = true,
gX = obj_cursor.x,
gY = obj_cursor.y,
mosX = floor(gX/gS)*gS,
mosY = floor(gY/gS)*gS,
abort = false;
// errors
with obj_generic_piece {
	if team == other.team {
		i++;	
	}
}
if i >= global.max_pieces {
	with obj_pawn_limit {
		scr_error();
	}
	abort = true;
}
if ((global.player_team == "friendly")? (global.friendly_turns < cost):(global.enemy_turns < cost)) {
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
	abort = true;
}
if cooldown > 0 {
	scr_error();
	abort = true;
}
if abort {
	audio_stop_sound(snd_pick_up);
	audio_stop_sound(snd_error);
	audio_stop_sound(snd_critical_error);
	audio_play_sound(snd_critical_error,0,0);
	return false;	
}
switch object_index {
	case obj_piece_slot:
	case obj_slot_selector:
	var info = piece_database(identity);
		instance_create_layer(gX,gY,"PieceUI",obj_dummy, {
			object: info[$ "object"],	
			sprite_index: info[$ "sprite"],
			turn_cost: cost,
			team: global.player_team,
			on_grid: info[$ "grid_placement_behavior"],
			on_piece: info[$ "piece_placement_behavior"],
			identity: identity, 
			orig_x: x, 
			orig_y: y,	
			link: id,
		});
	break;
	case obj_power_slot:
	var info = power_database(identity);
		instance_create_layer(gX,gY,"PieceUI",obj_dummy, {
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