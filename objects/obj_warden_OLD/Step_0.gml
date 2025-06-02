var gS = GRIDSPACE;

piece();

if !skip_move {
	switch execute {
		case "move":
			piece_attack(valid_moves[BOTH], BOTH);
		break;
	
		default:
			piece_interact();
		break;	
	}
} else { skip_move = false; }

with obj_profile {
	if team == other.team {
		hp = other.hp
	}
}



var tM = team; 
if hp <= 20 && damage_phase <= 0 {
	damage_phase += 1;
	hp = 20;
	audio_play_sound(snd_critical_hit,0,0);
	intangible = true;
	alarm[0] = game_get_speed(gamespeed_fps)*3.5;
	with obj_power_slot {
		if !usable && identity == 2 && global.player_team == tM {
			usable = true;
		}
	}
	if instance_exists(obj_world_one) {
		with obj_world_one {
			timer_mod = timer_mod*.9;	
		}
	}
}

if hp <= 10 && damage_phase <= 1 {
	damage_phase += 1;
	hp = 10;
	audio_play_sound(snd_critical_hit,0,0);
	intangible = true;
	alarm[0] = game_get_speed(gamespeed_fps)*3.5;
	with obj_power_slot {
		if !usable && identity == 3 && global.player_team == tM {
			usable = true;
		}
	}
	if instance_exists(obj_world_one) {
		with obj_world_one {
			timer_mod = timer_mod*.9;	
		}
	}
}

with obj_timer {
	if team == other.team {
		spd = other.spd;
		slw = other.slw;
	}
}