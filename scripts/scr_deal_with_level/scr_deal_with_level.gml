function deal_with_level(level) {
	var deployLoadout = global.loadout;
	default_game_rules();
	// Default level music
	var soundtrackPlay = GETOUTOFMYWAY;
	switch level[0] {
		case 0:
			// Base level function
			// Switch depending on type of base level
			switch level[1] {
				default:
					soundtrackPlay = BATTLE;
					deployLoadout = global.unlocked_pieces;
				break;
				case 1:
					soundtrackPlay = GETOUTOFMYWAYFULL;
				break;
			}
		break;
		case 1:
			instance_create_layer(x,y,"AboveBoard",obj_world_one);
			if level[1] != 8 {
				delete_team(global.opponent_team);
			}
			switch level[1] {
				case 1:
					scale_grid(1/7);
					global.barrier_criteria = 3;
					
					with obj_generic_hero {
						hp = 3;	
					}
					instance_destroy(obj_power_slot);		
					with obj_power_passive {
						y = 464;	
					}
				break;
				
				case 2:
					scale_grid(5/7);
					global.barrier_criteria = 3;
					with obj_generic_hero {
						hp = 3;	
					}
					instance_create_layer(832,384,"Instances",obj_wall, {
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
				break;
				
				case 4:
					var varStruct = {
						identity: "short",
						team: "friendly",
						tag: generate_tag(2),
						place_sound: noone
					}			
					soundtrackPlay = BATTLE;		
					instance_create_layer(640,192,"Instances",obj_short_shooter,varStruct);
					varStruct.tag = generate_tag(2);
					instance_create_layer(640,576,"Instances",obj_short_shooter,varStruct);	
					deployLoadout = ["short"];	
				break;
				
				case 8:
					soundtrackPlay = BATTLE;
					with obj_territory_friendly {
						image_xscale = 4;	
					}
					with obj_marker {
						x -= GRIDSPACE*3	
					}
					with obj_timer {
						if team == global.opponent_team {
							x += 6000;
						}
					}
					instance_destroy(obj_territory_blockade);
				break;
				
				default:
				break;
			}
		break;
	}	
	load_slots(deployLoadout);
	with obj_pawn_limit {
		visible = true;	
	}

	soundtrack_play(soundtrackPlay);
}