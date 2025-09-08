function verify_action(action){
	switch action.action {
		case "Spawn":
			var sX = x,
			sY = y,
			type = action.type,
			varObj = noone,
			varCost = 0;
			with obj_piece_slot {
				if identity == action.identity && team == action.team && index == action.index {
					if cooldown > 0	{
						return false;
					}
				}
			}
		
		return true;	
		case "Move":
			var varObj = action.tag,
			teamCheck = "";
			with obj_generic_piece {
				if tag != action.tag {
					continue;
				}
				if // Check if is on cooldown 
				move_cooldown_timer > 0 || 
				// Check if the grid doesn't exist
				!instance_exists(action.piece_on_grid) {
					return false;	
				}
				return true;
				/*				
				var arrayLengthMovesList = array_length(valid_moves),
				isValid = false;
				// From each valid_moves array, grab each moves list (ONLY_ATTACK, ONLY_MOVE, BOTH)
				for (var list = 0; list < arrayLengthMovesList; list++) {
					
					// Filter out dead arrays
					if valid_moves[list] == undefined || valid_moves[list] == 0 {
						continue;	
					}
					
					var list_array = valid_moves[list];
					var arrayLengthMoves = array_length(list_array);
					for (var moves = 0; moves < arrayLengthMoves; moves++) {
						
						if list_array == undefined {
							continue;	
						}			
						var precheckX = list_array[moves][0];
					    var precheckY = list_array[moves][1];
					    // Handle team & toggle string conversion
					    if is_string(precheckX) {
					        precheckX = tm_dp(real(precheckX), team, toggle);
					    }
					    if is_string(precheckY) {
					        precheckY = tm_dp(real(precheckY), team, toggle);
					    }
					    // Skip self-moves early
					    if precheckX == 0 && precheckY == 0 {
					        continue;
					    }
					    // Calculate move position
					    var moveToX = x + (precheckX + 0.5) * GRIDSPACE;
					    var moveToY = y + (precheckY + 0.5) * GRIDSPACE;
					    var testGrid = instance_position(moveToX, moveToY, action.piece_on_grid);
					    if !instance_exists(testGrid) {
					        continue;
					    }
						
						// Convert move to grid position
						var movePos = [floor((moveToX - testGrid.bbox_left) / GRIDSPACE),floor((moveToY - testGrid.bbox_top) / GRIDSPACE)];
						if action.grid_pos != movePos{
							continue;
						}
						isValid = true;
					}
				}
				
				var sylviaExists = false;
				with obj_generic_hero {
					if identity == "Empress" {
						sylviaExists = true;	
					}
				}
				return isValid || sylviaExists;
				*/
			}
		return false;
		default:
		return true;
	}
}
function execute_action(action,is_online){
	switch action.action {
		case "Spawn":
			var sX = x,
			sY = y,
			type = action.type,
			varObj = noone,
			debugOn = global.debug,
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

			if instance_exists(action.piece_on_grid) {
				sX = action.piece_on_grid.bbox_left +action.grid_pos[0]*GRIDSPACE;
				sY = action.piece_on_grid.bbox_top +action.grid_pos[1]*GRIDSPACE;
			}
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
					grid_pos = action.grid_pos;
					piece_on_grid = action.piece_on_grid;
					var tarX = grid_pos[0]*GRIDSPACE +piece_on_grid.bbox_left,
					tarY = grid_pos[1]*GRIDSPACE +piece_on_grid.bbox_top;
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
					x = tarX;
					y = tarY;
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
		break;
	}
}