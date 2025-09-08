function piece_handling() {
var clickedOn = noone;
// Debug functions
if global.debug {
	if input_check_pressed("special") {
		with obj_generic_piece {
			var zOff = 0,
			gridOff = piece_on_grid;
			if instance_exists(gridOff) { zOff += gridOff.z; }
			if collision_rectangle(bbox_left,bbox_top -zOff,bbox_right,bbox_bottom -zOff,obj_cursor,false,true) {
				clickedOn = id;
			}
		}
		with instance_position(obj_cursor.x,obj_cursor.y,obj_piece_slot) {
			switch object_index {
				case obj_piece_slot:
					cooldown = 0;
				break;
				case obj_power_slot:
					cooldown = 0;
				break;
			}
		}
		with clickedOn
		switch identity {
			default:
				move_cooldown_timer = 0; 
			break;
		}
	}
}
if input_check_pressed("action") && !instance_exists(obj_dummy) { 
	// Check if clicked on based on z coords
	if !instance_exists(clickedOn) {
		with obj_generic_piece {
			var zOff = 0,
			gridOff = piece_on_grid;
			if instance_exists(gridOff) { zOff += gridOff.z; }
			if collision_rectangle(bbox_left,bbox_top -zOff,bbox_right,bbox_bottom -zOff,obj_cursor,false,true) {
				clickedOn = id;
			}
		}		
	}
	if instance_exists(clickedOn) {
		switch global.mode {
			case "delete":
				if clickedOn.team == global.player_team {
					var del = {
						Message: SEND.GAMEDATA,
						action: "Delete",
						tag: clickedOn.tag,
					}
					array_push(requests,del);
				}
			break;
			default:
				if clickedOn.team == global.player_team && clickedOn != tutorial_piece {
					with obj_generic_piece {
						var zOff = 0,
						gridOff = piece_on_grid;
						if instance_exists(gridOff) { zOff += gridOff.z; }
						if team == global.player_team && !collision_rectangle(bbox_left,bbox_top -zOff,bbox_right,bbox_bottom -zOff,obj_cursor,false,true) {
							execute = "nothing";
						}
					}
					var ignoreClick = false;
					switch clickedOn.identity {
						case "accelerator":
							var checkNoExcess = ((clickedOn.team == "friendly")? (global.friendly_turns < global.max_turns):(global.enemy_turns < global.max_turns));
							if clickedOn.resource_timer >= clickedOn.time_to_produce && checkNoExcess {
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