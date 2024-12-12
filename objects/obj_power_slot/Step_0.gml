#macro PIECE 0
#macro POWER 1
if !usable || global.pause || skip || global.mode == "delete" {
	skip = false;
	exit;	
}
var hero = noone;
var linkTo = self
var cost = 1,
gX = obj_cursor.x,
gY = obj_cursor.y;
if position_meeting(gX,gY,self) && input_check_pressed("action") {
	if !instance_exists(obj_dummy) {
		select_sound(snd_pick_up);
		create = true;
	}

	with obj_generic_hero {
		if team == global.team {
			hero = identity
		}
	}
	if ((global.team == "friendly")? (global.turns >= cost):(global.enemy_turns >= cost)) {
		switch hero {
			case "Monarch":
				switch identity {
					case 1:
						instance_create_layer(gX,gY,"AboveBoard",obj_dummy, {
							obj_piece: obj_net_power,	
							sprite_index: spr_net_slot,
							turn_cost: 0,
							team: global.team,
							place_method: POWER,
							link: linkTo,
							on_grid: NONE,
							on_piece: ANY,
							identity: identity, 
							orig_x: x, 
							orig_y: y,
							exclude_barriers: true
						});	
					break;
					case 2:
						instance_create_layer(gX,gY,"AboveBoard",obj_dummy, {
							obj_piece: obj_fizz_power,	
							sprite_index: spr_fizz_slot,
							turn_cost: cost,
							team: global.team,
							place_method: POWER,
							link: linkTo,
							on_grid: ANY,
							on_piece: ANY,
							identity: identity, 
							orig_x: x,
							orig_y: y,
						});	
					break;
					case 3:
						instance_create_layer(gX,gY,"AboveBoard",obj_dummy, {
							obj_piece: obj_horde_power,	
							sprite_index: spr_horde_slot,
							turn_cost: cost,
							team: global.team,
							place_method: POWER,
							link: linkTo,
							on_grid: NEUTRAL,
							on_piece: NONE,
							identity: identity, 
							orig_x: x, 
							orig_y: y,
						});	
					break;
				}
			break;
			
			default:
			case "Warden":
				switch identity {
					case 1:
						instance_create_layer(gX,gY,"AboveBoard",obj_dummy, {
							obj_piece: obj_shield_power,	
							sprite_index: spr_generic_power_1,
							turn_cost: cost,
							team: global.team,
							place_method: POWER,
							link: linkTo,
							on_grid: NONE,
							on_piece: SAME,
							identity: identity, 
							orig_x: x, 
							orig_y: y,
						});	
					break;
					case 2:
						instance_create_layer(gX,gY,"AboveBoard",obj_dummy, {
							obj_piece: obj_earthshock_power,	
							sprite_index: spr_earthshock_slot,
							turn_cost: cost,
							team: global.team,
							place_method: POWER,
							link: linkTo,
							on_grid: ANY,
							on_piece: ANY,
							identity: identity, 
							orig_x: x,
							orig_y: y,
						});	
					break;
					case 3:
						instance_create_layer(gX,gY,"AboveBoard",obj_dummy, {
							obj_piece: obj_supercharge_power,	
							sprite_index: spr_supercharge_slot,
							turn_cost: cost,
							team: global.team,
							place_method: POWER,
							link: linkTo,
							on_grid: ANY,
							on_piece: ANY,
							identity: identity, 
							orig_x: x, 
							orig_y: y,
						});	
					break;
				}
			break;
		}		
	} else {
		audio_stop_sound(snd_critical_error);
		audio_stop_sound(snd_pick_up);
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