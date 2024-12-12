if piece() && !skip_move {
	switch execute {
		case "move":
			if input_check_pressed("action") {
				var
				gS = global.grid_spacing,
				gX = obj_cursor.x,
				gY = obj_cursor.y,
				mX = floor(gX/gS)*gS,
				mY = floor(gY/gS)*gS;
				if ((team == "friendly")?(global.turns >= cost):(global.enemy_turns >= cost)) {
					if !position_meeting(mX,mY,self) && position_meeting(mX,mY,obj_grid){
						instance_create_layer(mX,mY,"Instances",obj_bomb);
						if team == "friendly" {
							global.turns -= cost;	
						} else {
							global.enemy_turns -= cost;	
						}
						execute = "nothing";
					}
					if !position_meeting(mX,mY,obj_grid) {
						execute = "nothing";	
					}
				} else {
					audio_stop_sound(snd_pick_up);
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
					execute = "nothing";
				}
			}
		break;
	}
}

skip_move = false;