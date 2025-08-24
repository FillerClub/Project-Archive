y += y_spd*delta_time*DELTA_TO_FRAMES*.5*global.level_speed;	

if y > y_init {
	y = y_init;
	y_spd_max = y_spd_max/1.5;
	y_spd = y_spd_max;
} else { 
	y_spd += .05*delta_time*DELTA_TO_FRAMES*global.level_speed;
	y += y_spd*delta_time*DELTA_TO_FRAMES*.5*global.level_speed;	
}


// If hp changes
if hp < hp_init {
	hp_init--;
	if !ai_controlled {
		with obj_world_one {
			timer_mod = timer_mod*.95;	
		}		
	} else {
		with obj_world_one {
			hero_phase += 4;
		}
	}
}

if hp <= 0 {
	switch room {
		case rm_sandbox:
			hp = global.barrier_criteria;
			with obj_hero_wall {
				if team == other.team && total_health(hp) <= 0 {
					hp.base = 10;
					invincible = false;
				}
			}
		break;
		default:
			if !ai_controlled {
				instance_create_layer(x,y,"Instances",obj_death_hero,{
					sprite_index: sprite_index
				})
				room_goto(rm_gameover);
			} else {
				with obj_generic_piece {
					if team == global.opponent_team {
						instance_destroy();	
					}
				}
				with obj_world_one {
					if phase < HEROBATTLEEND {
						phase = HEROBATTLEEND;
					}
				}
			}
		break;
		case rm_level_conveyor:
		case rm_level_small:
		case rm_level_normal:
		case rm_level_split:
		case rm_level_heights:
			var lose = {
				Message: SEND.GAMEDATA,
				action: "Lose",
				team: team,
			}
			with obj_battle_handler {
				array_push(requests,lose);	
			}
		break;
	}
}
