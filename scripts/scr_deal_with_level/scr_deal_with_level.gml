function deal_with_level(level) {
	// Run this code on each level
	var gS = global.grid_spacing;
	if level[0] != 0 {
		with obj_slot_bg {
			var loadoutLength = array_length(global.loadout);
			for (var l = 0; l < loadoutLength; l++) {
				instance_create_layer(x +l*48,y,"Instances",obj_piece_slot,{
					identity: global.loadout[l]
				});				
			}
	
		}
	}
	switch level[0] {
		case 0:
			soundtrack_play(BATTLE);
		break;
		case 1:
			soundtrack_play(GETOUTOFMYWAY);
			instance_create_layer(x,y,"AboveBoard",obj_world_one);
			if level[1] != 5 {
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
				
				case 3:
					scale_grid(7);
				break;
				
				case 4:
					scale_grid(7);
				break;
				
				case 5:
					scale_grid(7);
				break;
			}
		break;
	}
}