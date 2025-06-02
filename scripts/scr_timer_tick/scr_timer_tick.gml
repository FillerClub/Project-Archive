function timer_tick(tick_amt = global.turn_increment){
	var onPlayersSide = team == global.player_team,
	xFrom = (bbox_left +bbox_right)/2,
	xTo = xFrom,
	yFrom = bbox_top,
	yTo = bbox_top -20;
	if team == "friendly" {
		if global.player_turns < global.max_turns {
			var amtIncrease = min(tick_amt,max(global.max_turns -global.player_turns,0));
			global.player_turns += amtIncrease;
			instance_create_layer(xFrom,yFrom,"GUI",obj_hit_fx, {
				hp: amtIncrease,
				x_target: xTo,
				y_target: yTo,
				diff_factor: 64,
				image_xscale: 2,
				image_yscale: 2
			});
			with obj_generic_hero {
				if team == "friendly" && abs(y_spd) < 2 {
					y_spd = -2;
					y_spd_max = -2;
				}
			}
			with obj_timer {
				if team == "friendly" {
					draw_mute_red_green = 1;	
				}
			}
			if onPlayersSide {
				audio_play_sound(snd_timer_cycle,0,0);
			}
		}
	} else {
		if global.opponent_turns < global.max_turns {
			var amtIncrease = min(tick_amt,max(global.max_turns -global.opponent_turns,0));
			global.opponent_turns += amtIncrease;
			instance_create_layer(xFrom,yFrom,"GUI",obj_hit_fx, {
				hp: amtIncrease,
				x_target: xTo,
				y_target: yTo,
				diff_factor: 64,
				image_xscale: 2,
				image_yscale: 2
			});
			with obj_generic_hero {
				if team == "enemy" && abs(y_spd) < 2 {
					y_spd = -2;
					y_spd_max = -2;
				}
			}
			with obj_timer {
				if team == "enemy" {
					draw_mute_red_green = 1;							
				}
			}
			if onPlayersSide {
				audio_play_sound(snd_timer_cycle,0,0);
			}			
		}	
	}
}