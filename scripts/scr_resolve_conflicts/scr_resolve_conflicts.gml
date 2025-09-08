function sort_actions_by_execution_priority(actions) {
    // Analyze each action to determine if it's an attack
    var prioritized = [];
    
    for (var i = 0; i < array_length(actions); i++) {
        var action = actions[i];
        var priority = calculate_execution_priority(action);
        
        array_push(prioritized, {
            action: action,
            priority: priority,
        });
    }
    
    // Sort by priority (higher = execute first)
    array_sort(prioritized, function(a, b) {
        return b.priority - a.priority;
    });
    
    // Extract sorted actions
    var result = [];
    for (var i = 0; i < array_length(prioritized); i++) {
        array_push(result, prioritized[i].action);
    }
    
    return result;
}

function calculate_execution_priority(action) {
    switch (action.action) {
        case "Delete":
            return 1000; // Highest - removes pieces from board
            
        case "Move":
            if (is_action_attack(action)) {
                return 200; // High - attack moves
            } else {
                return 100; // Low - non-attack moves
            }
            
        case "Spawn":
            return 70; // Medium - adds pieces to board
            
        case "Interact":
            return 65; // Medium-low - ability activation
            
        case "Lose":
            return 2000; // Ultra high - game ending
            
        default:
            return 50;
    }
}


function execute_actions_with_dependencies(actions, is_online) {
    var executed_count = 0;
    
    for (var i = 0; i < array_length(actions); i++) {
        var action = actions[i];
        
        // Re-validate action before execution (pieces may have died)
        if (!verify_action_current_state(action)) {
            show_debug_message("Action invalidated due to state change: " + action.action);
            continue;
        }
        
        execute_action(action, is_online);
        
        /*
		if variable_instance_exists(self, "actions_done") {
            action.tick_processed = tick_count;
            action.execution_order = executed_count;
            array_push(actions_done, action);
        }
        */
        executed_count++;
        
        // Optional: Log execution for debugging
        show_debug_message("Executed " + action.action + " (priority order " + string(executed_count) + ")");
    }
}

function verify_action_current_state(action) {
    switch (action.action) {
        case "Move":
        case "Interact":
        case "Delete":
            // Check if piece still exists
            with (obj_generic_piece) {
                if (tag == action.tag) {
                    return true; // Piece exists
                }
            }
            return false; // Piece was destroyed
            
        case "Spawn":
            // Check if spawn position is still valid and resources available
            return verify_spawn_still_valid(action);
            
        default:
            return true; // Other actions don't have dependencies
    }
}

function verify_spawn_still_valid(action) {
    // Check resources
    var cost = (action.type == 0) ? 
               piece_database(action.identity, "place_cost") : 
               power_database(action.identity, POWERDATA.COST);
    
    var available = (action.team == "friendly") ? 
                    global.friendly_turns : 
                    global.enemy_turns;
    
    if (available < cost) {
        return false;
    }
    
	var placementType = (action.type == 0) ? 
               piece_database(action.identity, "piece_placement_behavior") : 
               power_database(action.identity, POWERDATA.PLACEMENTONPIECE);
	
    // Check if position is still empty
    var target_x = action.piece_on_grid.bbox_left + action.grid_pos[0] * GRIDSPACE;
    var target_y = action.piece_on_grid.bbox_top + action.grid_pos[1] * GRIDSPACE;
    var meeting = position_meeting(target_x + GRIDSPACE/2, target_y + GRIDSPACE/2, obj_obstacle)
	switch placementType {
		case PLACEABLENONE:
			return !meeting;
		default:
			return true
	}
}
function is_action_attack(action) {
    if (action.action != "Move") {
        return false;
    }

    // Check if target position is occupied by enemy piece
    var target_x = action.piece_on_grid.bbox_left + action.grid_pos[0] * GRIDSPACE;
    var target_y = action.piece_on_grid.bbox_top + action.grid_pos[1] * GRIDSPACE;
    
    // Get moving piece's team
    var moving_piece_team = "",
	canMove = false;
    with (obj_generic_piece) {
        if (tag == action.tag) {
            moving_piece_team = team;
			var arrayLengthMovesList = array_length(valid_moves);
			// From each valid_moves array, grab each moves list (ONLY_ATTACK, ONLY_MOVE, BOTH)
			for (var list = 0; list < arrayLengthMovesList; list++) {
				// Filter out dead arrays
				if valid_moves[list] == undefined || valid_moves[list] == [] || list == ONLY_MOVE {
					continue;	
				}
				canMove = true;
			}		
			break;
        }
		
    }
	if !canMove {
		return false;	
	}
    // Check if there's an enemy piece at target position
    var collision = instance_position(target_x + GRIDSPACE/2, target_y + GRIDSPACE/2, obj_obstacle);
    if (collision != noone) {
        with (collision) {
            if total_health(hp) > 0 {
                return (team != moving_piece_team);
            }
        }
    }
    
    return false;
}


function resolve_conflicts(actions) {
    var resolved_actions = [];
    var position_conflicts = ds_map_create(); // [position_key] -> [array of competing actions]
    var resource_tracker = {
        friendly_turns: global.friendly_turns,
        enemy_turns: global.enemy_turns
    };
    
    // Group conflicting actions
    for (var i = 0; i < array_length(actions); i++) {
        var action = actions[i];
        if (action.action == "Move" || action.action == "Spawn") {
            var pos_key = get_position_key(action);
            
            if (!ds_map_exists(position_conflicts, pos_key)) {
                ds_map_set(position_conflicts, pos_key, []);
            }
            
            var conflict_list = ds_map_find_value(position_conflicts, pos_key);
            array_push(conflict_list, action);
            ds_map_set(position_conflicts, pos_key, conflict_list);
        } else {
            // Non-positional actions (Delete, Interact) - no conflicts
            if (check_resource_availability(action, resource_tracker)) {
                array_push(resolved_actions, action);
                update_resource_tracker(action, resource_tracker);
            }
        }
    }
    
    // Resolve position conflicts
    var pos_key = ds_map_find_first(position_conflicts);
    while (pos_key != undefined) {
		//show_message(position_conflicts);
        var competing_actions = ds_map_find_value(position_conflicts, pos_key);
        if (array_length(competing_actions) == 1) {
            // No conflict - single action
            var action = competing_actions[0];
            if check_resource_availability(action, resource_tracker) {
				array_push(resolved_actions, action);
                resource_tracker = update_resource_tracker(action, resource_tracker);
            }
        } else {
            // Multiple actions want same position - resolve conflict
            var winner = resolve_position_conflict_improved(competing_actions);
            if (winner != noone && check_resource_availability(winner, resource_tracker)) {
                array_push(resolved_actions, winner);
                resource_tracker = update_resource_tracker(winner, resource_tracker);
            }
        }
        
        pos_key = ds_map_find_next(position_conflicts, pos_key);
    }
    
    ds_map_destroy(position_conflicts);
    return resolved_actions;
}

function check_resource_availability(action, resource_tracker) {
    var available_resources = 1,
	cost = 0,
	tM = "";
	switch action.action {
		case "Move":
			with obj_generic_piece {
				if action.tag == tag {
					cost = piece_database(identity, "move_cost");
					tM = team;
					
				}
			}
			available_resources = (tM == "friendly") ? 
               resource_tracker.friendly_turns : 
               resource_tracker.enemy_turns;		
		break;
		
		case "Spawn":
			cost = (action.type == 0) ? 
               piece_database(action.identity, "place_cost") : 
               power_database(action.identity, POWERDATA.COST);
    
			available_resources = (tM == "friendly") ? 
               resource_tracker.friendly_turns : 
               resource_tracker.enemy_turns;
		break;
	}	
    return available_resources >= cost
}

function update_resource_tracker(action, resource_tracker) {
    var available_resources = 1,
	cost = 0,
	tM = "";
	switch action.action {
		case "Move":
			with obj_generic_piece {
				if action.tag == tag {
					cost = piece_database(identity, "move_cost");
					tM = team;
				}
			}		
			if (tM == "friendly") {
				resource_tracker.friendly_turns -= cost;
			} else {
				resource_tracker.enemy_turns -= cost;
			}               		
		break;
		case "Spawn":
			cost = (action.type == 0) ? 
               piece_database(action.identity, "place_cost") : 
               power_database(action.identity, POWERDATA.COST);
    
			if (action.team == "friendly") {
				resource_tracker.friendly_turns -= cost;
			} else {
				resource_tracker.enemy_turns -= cost;
			} 
		break;
	}	
	return resource_tracker;
}

function get_position_key(action) {
    return string(action.piece_on_grid) + "," + 
           string(action.grid_pos[0]) + "," + 
           string(action.grid_pos[1]);
}

function resolve_position_conflict_improved(competing_actions) {
    // Sort by priority
    array_sort(competing_actions, function(a, b) {
        return calculate_action_priority(b) - calculate_action_priority(a);
    });
    
    // Return highest priority action that passes additional checks
    for (var i = 0; i < array_length(competing_actions); i++) {
        var action = competing_actions[i];
        
        // Additional conflict resolution rules
        if (action.action == "Move") {
            // Check if the piece can actually make this move
            with obj_generic_piece {
				if action.tag == tag {
					return action;
				}
			}
        } else if (action.action == "Spawn") {
            // Spawn always wins over move if resources available
            return action;
        }
    }
    
    return noone; // No valid action found
}

function sort_actions_by_priority(actions) {
    // Create array of {action, priority} pairs
    var prioritized = [];
    
    for (var i = 0; i < array_length(actions); i++) {
        var action = actions[i];
        var priority = calculate_action_priority(action);
        array_push(prioritized, {action: action, priority: priority});
    }
    
    // Sort by priority (higher number = higher priority)
    array_sort(prioritized, function(a, b) {
        return b.priority - a.priority;
    });
    
    // Extract just the actions
    var result = [];
    for (var i = 0; i < array_length(prioritized); i++) {
        array_push(result, prioritized[i].action);
    }
    
    return result;
}

function calculate_action_priority(action) {
    var base_priority = 0;
    
    switch (action.action) {
        case "Delete":
            return 250; // Highest priority - removes pieces others might target
            
        case "Move":
            // Higher attack power gets priority in movement conflicts
			var pieceAtk = 0;
			with obj_generic_piece {
				if tag == action.tag {
					pieceAtk = attack_power;
				}
			}
            return 50 + pieceAtk;
            
        case "Spawn":
            return 25; // Medium priority
            
        case "Interact":
            return 10; // Low priority
            
        default:
            return 0;
    }
}
enum CONFLICT {
    NONE,
    POSITION,
    RESOURCE,
    STATE,
	IGNORE,
}

function detect_conflict(action, resolved_actions, position_map, resource_tracker) {
    switch (action.action) {
        case "Move":
            return detect_move_conflict(action, position_map, resolved_actions);
            
        case "Spawn":
            return detect_spawn_conflict(action, position_map, resource_tracker);
    }
    
    return CONFLICT.NONE;
}

function detect_move_conflict(action, position_map, resolved_actions) {
    var target_key = string(action.piece_on_grid) + "," + 
                    string(action.grid_pos[0]) + "," + 
                    string(action.grid_pos[1]);
    
    if (ds_map_exists(position_map, target_key)) {
		return CONFLICT.POSITION;
    }
    var resolvedAmt = array_length(resolved_actions); 
	for (var r = 0; r < resolvedAmt; r++) {
		if resolved_actions[r].tag == action.tag {
			return CONFLICT.IGNORE;
		}
	}
    return CONFLICT.NONE;
}

function detect_spawn_conflict(action, position_map, resource_tracker) {
    var cost = (action.type == 0) ? 
               piece_database(action.identity, "place_cost") : 
               power_database(action.identity, POWERDATA.COST);
    
    var available_resources = (action.team == "friendly") ? 
                             resource_tracker.friendly_turns : 
                             resource_tracker.enemy_turns;
    
    if (available_resources < cost) {
        return CONFLICT.RESOURCE;
    }
    
    // Check if trying to spawn on occupied position
    var target_key = string(action.piece_on_grid) + "," + 
                    string(action.grid_pos[0]) + "," + 
                    string(action.grid_pos[1]);
    
    // Check existing pieces or spawns this tick
	if (ds_map_exists(position_map, target_key)) {
        return CONFLICT.POSITION;
    }
    
    return CONFLICT.NONE;
}
function resolve_position_conflict(new_action, position_map) {
    var target_key = string(new_action.piece_on_grid) + "," + 
                    string(new_action.grid_pos[0]) + "," + 
                    string(new_action.grid_pos[1]);
    
    var existing_action = ds_map_find_value(position_map, target_key);
    
    if (new_action.action == "Move" && existing_action.action == "Move") {
        // Handle last movement if same pieces does an action multiple times
		show_message(new_action.tag == existing_action.tag)
		if new_action.tag == existing_action.tag {
			return new_action;
		}
		// Both trying to move to same spot - higher attack power wins
        var new_attack = 0;
        var existing_attack = 0;
		with obj_generic_piece {
			if tag == new_action.tag {
				new_attack = attack_power;
			}
			if tag == existing_action.tag {
				existing_attack = attack_power;
			}
		}

        if (new_attack > existing_attack) {
            return new_action;
        } else if (new_attack < existing_attack) {
            return existing_action;
        } else {
            // Same attack power - whatever is first
            return existing_action;
        }
    } 
    // Default: existing action wins
    return existing_action;
}


function deduplicate_actions(actions) {
    var piece_action_map = ds_map_create(); // [piece_tag] -> latest_action
    var spawn_position_map = ds_map_create(); // [position_key + team] -> latest_spawn
    var final_actions = [];
    
    // Process actions in order, keeping only the LAST action per piece
    for (var i = 0; i < array_length(actions); i++) {
        var action = actions[i];
        
        switch (action.action) {
            case "Move":
            case "Interact": 
            case "Delete":
                // Only allow ONE action per piece per tick
                var piece_key = action.tag + "_" + action.action;
                
                // Check if this is a no-op move
                if (action.action == "Move" && is_noop_move(action)) {
                    continue; // Skip no-op moves
                }
                
                ds_map_set(piece_action_map, piece_key, action);
                break;
                
            case "Spawn":
                // Only allow ONE spawn per position per team per tick
                var spawn_key = string(action.piece_on_grid) + "," + 
                              string(action.grid_pos[0]) + "," + 
                              string(action.grid_pos[1]) + "_" + action.team;
                ds_map_set(spawn_position_map, spawn_key, action);
                break;
        }
    }
    
    // Collect final actions from maps
    var piece_key = ds_map_find_first(piece_action_map);
    while (piece_key != undefined) {
        array_push(final_actions, ds_map_find_value(piece_action_map, piece_key));
        piece_key = ds_map_find_next(piece_action_map, piece_key);
    }
    
    var spawn_key = ds_map_find_first(spawn_position_map);
    while (spawn_key != undefined) {
        array_push(final_actions, ds_map_find_value(spawn_position_map, spawn_key));
        spawn_key = ds_map_find_next(spawn_position_map, spawn_key);
    }
    
    ds_map_destroy(piece_action_map);
    ds_map_destroy(spawn_position_map);
    
    return final_actions;
}

function is_noop_move(action) {
    // Check if piece is already at target position
    with (obj_generic_piece) {
        if (tag == action.tag) {
           
            return (grid_pos == action.grid_pos && 
                   piece_on_grid == action.piece_on_grid);
        }
    }
    return false; // Piece not found, let validation handle it
}