function read_requests(ar,is_online = false) {
	var len = array_length(ar);
	if len <= 0 {
		exit;	
	}
	var read = array_shift(ar); 
	switch read.action {
		case DATA.SPAWN:
			var sX = x,
			sY = y,
			type = undefined,
			varObj = noone,
			varCost = 0;
			with obj_piece_slot {
				if identity == read.identity && team == read.team {
					cooldown = cooldown_length;
					type = object_index;
				}
			}
			switch type {
				case obj_piece_slot:
					varObj = piece_database(read.identity,PIECEDATA.OBJECT);
					varCost = piece_database(read.identity,PIECEDATA.PLACECOST);
				break;
				case obj_power_slot:
					varObj = power_database(read.identity,POWERDATA.OBJECT);
					varCost = power_database(read.identity,POWERDATA.COST);
				break;
			}

			if instance_exists(read.piece_on_grid) {
				sX = read.piece_on_grid.bbox_left +read.grid_pos[0]*GRIDSPACE;
				sY = read.piece_on_grid.bbox_top +read.grid_pos[1]*GRIDSPACE;
			}
			if read.team == "friendly" { global.friendly_turns -= varCost; }
			if read.team == "enemy" { global.enemy_turns -= varCost; }		
			with instance_create_layer(sX,sY,"Instances",varObj, {
				identity: read.identity,
				team: read.team,
				grid_pos: read.grid_pos,
				piece_on_grid: read.piece_on_grid,
				skip_move: true,					
			}) {
				if is_online {
					tag = read.tag;	
				}
			}
		break;
		case DATA.MOVE:
			var varObj = obj_generic_piece;
			if !is_online {
				varObj = read.tag;
			}
			with varObj {
				if tag == read.tag {
					grid_pos = read.grid_pos;
					piece_on_grid = read.piece_on_grid;
					var tarX = grid_pos[0]*GRIDSPACE +piece_on_grid.bbox_left,
					tarY = grid_pos[1]*GRIDSPACE +piece_on_grid.bbox_top;
					move_cooldown_timer = move_cooldown;
					moved = true;
					if position_meeting(tarX +GRIDSPACE/2,tarY +GRIDSPACE/2,obj_obstacle) {
						var collide = instance_position(tarX +GRIDSPACE/2,tarY +GRIDSPACE/2,obj_obstacle);
						hurt(collide.hp,attack_power,collide);
						// Hurt behavior depending on object
						switch collide.object_index {
							// Never destroy a hero wall
							case obj_hero_wall:
								instance_destroy();			
							break;
				
							default:
								if total_health(collide.hp) <= 0 {
									// Destroy target piece if it's hp is 0
									instance_destroy(collide);
								} else {
									// Destroy the attacking piece if it's too weak
									instance_destroy();	
								}

							break;									
						}
					}
					
					if team == global.player_team { execute = "move"; }
					if team == "friendly" { global.friendly_turns -= cost; }
					if team == "enemy" { global.enemy_turns -= cost; }	
					x = tarX;
					y = tarY;
					audio_stop_sound(snd_move);
					audio_play_sound(snd_move,0,0);
					// Activate move event
					event_perform(ev_other,ev_user0);
				}
			}
		break;
		case DATA.INTERACT:
			var varObj = obj_generic_piece;
			if !is_online {
				varObj = read.tag;
			}
			with varObj {
				if tag == read.tag {
					event_perform(ev_other,ev_user1);
				}
			}
		break;
		case DATA.DELETE:
			var varObj = obj_generic_piece;
			if !is_online {
				varObj = read.tag;
			}
			with varObj {
				if tag == read.tag {
					instance_destroy();
				}
			}
		break;
		case DATA.LOSE:
			with obj_generic_piece {
				if team == read.team {
					instance_destroy();	
				}
			}
			with obj_bullet_parent {
				if team == read.team {
					instance_destroy();	
				}
			}
			with obj_generic_hero {
				if team == read.team {
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