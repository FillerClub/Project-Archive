
function piece_attack(valid_attacks = [0,0], mode = BOTH, cost = 1, bypass_cooldown = false) {
#macro ONLY_MOVE 0
#macro ONLY_ATTACK 1 
#macro BOTH 2
#macro FAUX 3

// Cache cursor instance and properties
var cursorInstance = obj_cursor;
if !instance_exists(cursorInstance) {
    return false;
}

var cursorX = cursorInstance.x,
    cursorY = cursorInstance.y,
    cursorOnGrid = cursorInstance.on_grid,
    cursorGridPosition = cursorInstance.grid_pos;

if !instance_exists(cursorOnGrid) {
    return false;
}

// Check for piece click
var piececlick = [noone],
clickIndex = 0,
clickedOnSelf = false,
selfZ = z,
selfGrid = piece_on_grid;
if is_string(selfGrid) {
	with obj_grid {
		if tag == selfGrid {
			selfZ += z;
			selfGrid = id;
			break;
		}
	}
} else {
	selfZ += (instance_exists(selfGrid) ? selfGrid.z : 0);	
}


with obj_obstacle {
	if variable_instance_exists(self,"piece_on_grid") {
		var targetZ = 0;
		if is_string(piece_on_grid) {
			with obj_grid {
				if tag == other.piece_on_grid {
					targetZ += z;
					break;
				}
			}
		} else { targetZ += (instance_exists(piece_on_grid) ? piece_on_grid.z : 0);	}
	} else { continue; }
	
    // Collision check
    if point_in_rectangle(cursorX, cursorY, bbox_left, bbox_top - targetZ, bbox_right, bbox_bottom - targetZ) {
        if mode == ONLY_MOVE {
			exit;	
		}
		// Skip self and same team
		if id == other.id || team == other.team {
			clickedOnSelf = true;
		} else if invincible != true && total_health(hp) > 0 {
			piececlick[clickIndex] = id;		
			clickIndex++;
		}
    }
}
// Validate piece click
if (clickedOnSelf || mode == ONLY_ATTACK) && clickIndex <= 0 {
	return false;	
}

// Cooldown check
if !bypass_cooldown && move_cooldown_timer > 0 {
    scr_error();
    audio_stop_sound(snd_critical_error);
    audio_play_sound(snd_critical_error, 0, 0);
    return false;
}

// Territory blockade check
if position_meeting(cursorX, cursorY, obj_territory_blockade) {
    var sound_params = {
        sound: snd_oip,
        pitch: random_range(0.85, 1.15),
    };
    repeat(45) {
        part_particles_burst(global.part_sys, cursorX, cursorY, part_slap);
    }
    audio_play_sound_ext(sound_params);
    return false;
}

// Find valid moves
var ar_leng = array_length(valid_attacks),
moveToGrid = noone,
finalX = 0,
finalY = 0,
highLowKey = input_check("alternate_key"),
compareZ = 0;
if highLowKey {
	compareZ = infinity;
} else {
	compareZ = -infinity	
}

for (var i = 0; i < ar_leng; i++) {
    var precheckX = valid_attacks[i][0];
    var precheckY = valid_attacks[i][1];
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
    var testGrid = instance_position(moveToX, moveToY, obj_grid);
    if !instance_exists(testGrid) {
        continue;
    } 
    // Grid position calculation
    var gClampX =  floor((moveToX - testGrid.bbox_left) / GRIDSPACE),
    gClampY = floor((moveToY - testGrid.bbox_top) / GRIDSPACE),
	backX = testGrid.bbox_left +gClampX*GRIDSPACE,
	backY = testGrid.bbox_top + gClampY*GRIDSPACE;
    // Check if cursor is over this move position
    if point_in_rectangle(cursorX, cursorY, 
                         backX, backY - testGrid.z,
                         backX + GRIDSPACE, backY + GRIDSPACE - testGrid.z) {
        var conditionCheck = false;
		// Height validation
        if max(testGrid.z - selfZ, 0) > climb_height || 
           max(selfZ - testGrid.z, 0) > drop_height {
           continue;
        }
		if highLowKey {
			if testGrid.z < compareZ {
				compareZ = testGrid.z;
				conditionCheck = true;
			}			
		} else {
			if testGrid.z > compareZ {
				compareZ = testGrid.z;
				conditionCheck = true;
			}
		}
		if !conditionCheck { 
			continue;	
		}
        moveToGrid = testGrid;
		finalX = gClampX;
		finalY = gClampY;
    }
}

if !instance_exists(moveToGrid) {
    return false;
}

// Cost validation
var canAfford = false;
switch team {
    case "friendly":
        canAfford = global.friendly_turns >= cost;
        if canAfford global.friendly_turns -= cost;
        break;
        
    case "enemy":
        canAfford = global.enemy_turns >= cost;
        if canAfford global.enemy_turns -= cost;
        break;
}
// Error handling
if !canAfford {
    audio_stop_sound(snd_critical_error);
    audio_play_sound(snd_critical_error, 0, 0);
    
    if team == global.player_team {
        with obj_timer { scr_error(); }
        with obj_turn_operator { scr_error(); }
    }
    return false;
}

// Execute the move
r_move_piece(tag, [finalX, finalY], moveToGrid.tag, grid_pos, selfGrid.tag, bypass_cooldown);
return true;
}