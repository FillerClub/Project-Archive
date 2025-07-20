function piece_handling() {
if input_check_pressed("action") && !instance_exists(obj_dummy) { 
	var clickedOn = instance_position(obj_cursor.x,obj_cursor.y,obj_generic_piece);	
	if clickedOn != noone {
		switch global.mode {
			case "delete":
				var del = {
					action: DATA.DELETE,
					tag: clickedOn.tag,
				}
				array_push(requests,del);
			break;
			default:
				if clickedOn.team == global.player_team && clickedOn != tutorial_piece {
					with obj_generic_piece {
						if team == global.player_team && !position_meeting(obj_cursor.x,obj_cursor.y,self) {
							execute = "nothing";
						}
					}
					var ignoreClick = false;
					switch clickedOn.identity {
						case "accelerator":
							if clickedOn.resource_timer >= clickedOn.time_to_produce {
								ignoreClick = true;
							}
						default:
							if ignoreClick {
								clickedOn.skip_click = true;
								break;	
							}
							if clickedOn.execute != "move" {
								clickedOn.execute = "move";	
								clickedOn.skip_click = true;
								audio_stop_sound(snd_put_down);
								audio_play_sound(snd_pick_up,0,0);
							} else {
								clickedOn.execute = "nothing";
								audio_stop_sound(snd_pick_up);
								audio_play_sound(snd_put_down,0,0);
							}			
						break;
					}
				}
			break;
		}
	}
}
}