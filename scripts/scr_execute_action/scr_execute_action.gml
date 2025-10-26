function execute_action(action,is_online){
	switch action.action_type {
		case "Spawn":
			var sX = x,
			sY = y,
			type = action.type,
			varObj = noone,
			debugOn = global.debug,
			timeDiff = ((get_timer() -game_clock_start -action.time_stamp))/1000000,
			varCost = 0;
			if !debugOn {
				with obj_piece_slot {
					if identity == action.identity && team == action.team && index == action.index {
						cooldown = cooldown_length;
						break;
					}
				}
			}
			switch type {
				case 0:
					varObj = piece_database(action.identity,"object");
					varCost = piece_database(action.identity,"place_cost");
				break;
				case 1:
					varObj = power_database(action.identity,POWERDATA.OBJECT);
					varCost = power_database(action.identity,POWERDATA.COST);
				break;
			}
			var gridRef = action.piece_on_grid;
			if is_string(gridRef) {
				with obj_grid {
					if gridRef == tag {
						gridRef = id;
						break;
					}
				}
			}
			if !instance_exists(gridRef) { break; }
			sX = gridRef.bbox_left +action.grid_pos[0]*GRIDSPACE;
			sY = gridRef.bbox_top +action.grid_pos[1]*GRIDSPACE;

			if !debugOn {
				if action.team == "friendly" { global.friendly_turns -= varCost; }
				if action.team == "enemy" { global.enemy_turns -= varCost; }	
			}
			with instance_create_layer(sX,sY,"Instances",varObj, {
				identity: action.identity,
				team: action.team,
				grid_pos: action.grid_pos,
				piece_on_grid: action.piece_on_grid,
				skip_move: true,
				link: action.link,
			}) {
				if is_online {
					tag = action.tag;	
				}
				if variable_instance_exists(self,"uses_timer") && variable_instance_exists(self,"timer") {
					if uses_timer {
						timer += timeDiff;	
					}
				}
			}
		break;
		case "Move":
			var varObj = obj_generic_piece,
			teamCheck = "";
			if !is_online {
				varObj = action.tag;
			}
			with varObj {
				if tag == action.tag {
					var gridRef = action.piece_on_grid;
					if is_string(gridRef) {
						with obj_grid {
							if gridRef == tag {
								gridRef = id;
								break;
							}
						}
					}
					if !instance_exists(gridRef) { break; }
					grid_pos = action.grid_pos;
					piece_on_grid = gridRef;
					var tarX = grid_pos[0]*GRIDSPACE +gridRef.bbox_left,
					tarY = grid_pos[1]*GRIDSPACE +gridRef.bbox_top;
					if position_meeting(tarX +GRIDSPACE/2,tarY +GRIDSPACE/2,obj_obstacle) {
						var collide = instance_position(tarX +GRIDSPACE/2,tarY +GRIDSPACE/2,obj_obstacle);
						hurt(collide.hp,attack_power,DAMAGE.PHYSICAL,collide);
						// Hurt behavior depending on object
						switch collide.object_index {
							// Never destroy a hero wall
							case obj_hero_wall:
								instance_destroy();			
							break;
				
							default:
								if total_health(collide.hp) <= 0 {
									// Destroy target piece if it's hp is 0
									teamCheck = team;
									instance_destroy(collide);
								} else {
									// Destroy the attacking piece if it's too weak
									instance_destroy();	
								}
							break;									
						}
					}
					if !action.bypass_cooldown {
						if team == global.player_team { execute = "move"; }
						if team == "friendly" { global.friendly_turns -= cost; }
						if team == "enemy" { global.enemy_turns -= cost; }
						move_cooldown_timer = move_cooldown;
					}
					// Create dash particle
					var dashPart = -1;
					with obj_battle_handler {
						dashPart = dash_part;
					}
					if dashPart != -1 {
						var angleSet = point_direction(x,y,tarX,tarY) ;
						part_type_orientation(dashPart,angleSet +90,angleSet +90,0,0,0);
						part_type_direction(dashPart,angleSet +180,angleSet +180,0,0);
						part_particles_create(global.part_sys,x +sprite_width/2,y +sprite_height/2,dashPart,1);
					}
					x = tarX;
					y = tarY;
					if ds_exists(interpolation_data,ds_type_map) {
						ds_map_clear(interpolation_data);
					}
					audio_stop_sound(snd_move);
					audio_play_sound(snd_move,0,0);
					// Activate move event
					event_perform(ev_other,ev_user0);
				}
			}
			if teamCheck != "" {
				with obj_constant_reload {
					if teamCheck != team {
						continue;
					}
					if ammo < 6 {
						audio_play_from_array([snd_lonestar_reload],.2);
						ammo++;
					}
				}
			}
		break;
		case "Interact":
			var varObj = obj_generic_piece;
			if !is_online {
				varObj = action.tag;
			}
			with varObj {
				if tag == action.tag {
					event_perform(ev_other,ev_user1);
				}
			}
		break;
		case "Delete":
			var varObj = obj_generic_piece;
			if !is_online {
				varObj = action.tag;
			}
			with varObj {
				if tag == action.tag {
					instance_destroy();
				}
			}
		break;
		case "Lose":
			if instance_exists(obj_death_hero) {
				break;
			}
			with obj_generic_piece {
				if team == action.team {
					instance_destroy();	
				}
			}
			with obj_bullet_parent {
				if team == action.team {
					instance_destroy();	
				}
			}
			
			with obj_generic_hero {
				if team == action.team {
					instance_create_layer(x,y,"Instances",obj_death_hero,{
						sprite_index: sprite_index,
						online: true,
					})
					instance_destroy();					
				}
			}
			audio_group_stop_all(track1);
			audio_group_stop_all(track2);
			audio_group_stop_all(track3);
			audio_group_stop_all(track4);
		break;
	}
}