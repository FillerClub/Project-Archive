event_inherited();



if global.game_state != PAUSED{
	var tM = ((team == "friendly")?1:-1)*(1 -toggle*2),
	gS = GRIDSPACE;
	if position_meeting(x +tM*gS,y,obj_obstacle) {
		with instance_position(x +tM*gS,y,obj_obstacle) {
			if hp > 0 && team == other.team {
				other.skip_timer = true;	
			} else {
				other.skip_timer = false;
			}
		}
	} else { skip_timer = false; }

	if timer >= timer_end && moving {
		var canMove = true;
		var still = false;
		if !position_meeting(x +tM*gS,y,obj_grid) {
			toggle = (toggle)?false:true;
		} else {
			var inst = instance_position(x +tM*gS,y,obj_obstacle);
			if inst != -4 {
				if (inst.hp <= 0) || (inst.team == team) {
					toggle = (toggle)?false:true;	
				} 
			}
		}
	
		tM = ((team == "friendly")?1:-1)*(1 -toggle*2);
		
		
		if !position_meeting(x +tM*gS,y,obj_grid) {
			canMove = false;	
		} else if position_meeting(x +tM*gS,y,obj_obstacle) {
			with instance_position(x +tM*gS,y,obj_obstacle) {
				if team == other.team {
					canMove = false;
				}	
				if team != other.team {
					if hp > 0 {
						hp -= 15;
						if hp > 0 {
							canMove = false
							audio_stop_sound(snd_giant_step);
							audio_play_sound(snd_giant_step,0,0);
						}
					} else {
						still = true;	
					}
				}
			}
		}
	
		if canMove {
			if !still {
				x += tM*gS;	
				timer = 0;
				audio_play_sound(snd_giant_step,0,0);
			}
		} else {
			toggle = (toggle)?false:true;
			tM = ((team == "friendly")?1:-1)*(1 -toggle*2);	
		}
	}


}

