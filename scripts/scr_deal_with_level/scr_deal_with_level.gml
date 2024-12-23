function deal_with_level(level) {
	var gS = global.grid_spacing;
	// Load loadout
	var skip1_4 = !(level[0] == 1 && level[1] == 4); 
	if level[0] != 0 && skip1_4 {
		with obj_slot_bg {
			var loadoutLength = array_length(global.loadout);
			for (var l = 0; l < loadoutLength; l++) {
				instance_create_layer(x +l*48,y,"Instances",obj_piece_slot,{
					identity: global.loadout[l]
				});				
			}
	
		}
	}
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
				break;
				
				case 4:	
					soundtrackPlay = BATTLE;
					with obj_pawn_limit {
						visible = false;	
					}
					
					scale_grid(7);
				break;
				
				default:
					scale_grid(7);
				break;
			}
		break;
	}
	soundtrack_play(soundtrackPlay);
}