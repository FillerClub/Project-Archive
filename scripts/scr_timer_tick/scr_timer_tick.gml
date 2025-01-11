// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function timer_tick(tick_amt = global.turn_increment){
	var onPlayersSide = team == global.team;
	
	if team == "friendly" {
		if global.turns < global.max_turns {
			with obj_generic_hero {
				if team == "friendly" && y_spd == 0 {
					y_spd = -2;
					y_spd_max = -2;
				}
			}
			global.turns = min(global.turns +tick_amt,global.max_turns);
			draw_mute_red_green = 1;
			if onPlayersSide {
				audio_play_sound(snd_timer_cycle,0,0);
			}
		}
	} else {
		if global.enemy_turns < global.max_turns {
			with obj_generic_hero {
				if team == "enemy" && y_spd == 0 {
					y_spd = -2;
					y_spd_max = -2;
				}
			}
			global.enemy_turns =  min(global.enemy_turns +tick_amt,global.max_turns);
			draw_mute_red_green = 1;
			if onPlayersSide {
				audio_play_sound(snd_timer_cycle,0,0);
			}			
		}	
	}
}