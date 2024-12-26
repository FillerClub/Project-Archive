function deal_with_level(level) {
	var gS = global.grid_spacing;

	// Default level music
	var soundtrackPlay = GETOUTOFMYWAY;
	switch level[0] {
		case 0:
			soundtrackPlay = BATTLE;
		break;
		case 1:
			instance_create_layer(x,y,"AboveBoard",obj_world_one);
			if level[1] != 8 {
				delete_team(global.enemy_team);
			}
			switch level[1] {
				case 1:
					global.max_barriers = 3;
					with obj_generic_hero {
						hp = 3;	
					}
					instance_destroy(obj_mode);
					instance_destroy(obj_power_slot);		
					with obj_power_passive {
						y = 464;	
					}
				break;
				
				case 2:
					global.max_barriers = 3;
					with obj_generic_hero {
						hp = 3;	
					}
					scale_grid(5);
					instance_create_layer(832,384,"Instances",obj_generic_piece, {
						identity: "barrel",	
						place_sound: undefined,
					});
					instance_destroy(obj_power_slot);	
					with obj_power_passive {
						y = 464;	
					}
				break;
				
				case 3:
					instance_destroy(obj_power_slot);	
					with obj_power_passive {
						y = 464;	
					}
					scale_grid(7);
				break;
				
				case 4:
					var varStruct = {
						identity: "short",
						team: "friendly",
						place_sound: noone
					}			
					soundtrackPlay = BATTLE;
					scale_grid(7);			
					instance_create_layer(640,192,"Instances",obj_short_shooter,varStruct);																			
					instance_create_layer(640,576,"Instances",obj_short_shooter,varStruct);						
				break;
				
				default:
					scale_grid(7);
				break;
			}
		break;
	}
	// Load loadout
	if (level[0] == 1 && level[1] == 4) {
		global.loadout = ["short"];	
	}
	if level[0] != 0{
		with obj_slot_bg {
			if team == global.team {
				var loadoutLength = array_length(global.loadout);
				for (var l = 0; l < loadoutLength; l++) {
					instance_create_layer(x +l*48,y,"Instances",obj_piece_slot,{
						identity: global.loadout[l]
					});				
				}
			}
		}
		with obj_pawn_limit {
			visible = true;	
		}
	}
	soundtrack_play(soundtrackPlay);
}