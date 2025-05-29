function deal_with_level(level) {
	var gS = GRIDSPACE;
	var deployLoadout = global.loadout;
	// Default level music
	var soundtrackPlay = GETOUTOFMYWAY;
	switch level[0] {
		case 0:
			switch room {
				default:
					soundtrackPlay = BATTLE;
				break;
				case rm_debug_room:
					soundtrackPlay = noone;
				break;
			}
			deployLoadout = global.unlocked_pieces;
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
					deployLoadout = ["short"];	
				break;
				
				case 8:
					soundtrackPlay = BATTLE;
					with obj_territory_friendly {
						image_xscale = 4;	
					}
					with obj_marker {
						x -= gS*3	
					}
					with obj_timer {
						if team == global.enemy_team {
							x += 6000;
						}
					}
					instance_destroy(obj_territory_blockade);
					scale_grid(7);
				break;
				
				default:
					scale_grid(7);
				break;
			}
		break;
	}
	

	with obj_slot_bg {
		if team == global.team {
			var loadoutLength = array_length(deployLoadout);
			for (var l = 0; l < loadoutLength; l++) {
				instance_create_layer(x +l*48,y,"Instances",obj_piece_slot,{
					identity: deployLoadout[l]
				});				
			}
		}
	}
	with obj_pawn_limit {
		visible = true;	
	}
	
	soundtrack_play(soundtrackPlay);
}