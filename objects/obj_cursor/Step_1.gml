var cursorMargin = GUI_MARGIN,
cam = view_camera[0],
camX = camera_get_view_x(cam),
camY = camera_get_view_y(cam),
minCoordx = camX +cursorMargin,
minCoordy = camY +cursorMargin,
maxX =  camX +room_width -cursorMargin,
maxY = camY +room_height -cursorMargin,
highLowKey = input_check("alternate_key"),
compareZ = 0;
on_grid = noone;
if highLowKey {
	compareZ = infinity;
} else {
	compareZ = -infinity	
}
// With grid
with obj_grid {
	if point_in_rectangle(other.x,other.y,bbox_left,bbox_top -z,bbox_right -1,bbox_bottom -z -1) {
		var conditionCheck = false;
		if highLowKey {
			if z < compareZ {
				compareZ = z;
				conditionCheck = true;
			}			
		} else {
			if z > compareZ {
				compareZ = z;
				conditionCheck = true;
			}
		}
		if !conditionCheck { 
			continue;	
		}
		var grabPos = [floor((other.x -bbox_left)/GRIDSPACE),floor((other.y -(bbox_top -z))/GRIDSPACE)];
		other.on_grid = id;
		other.grid_pos = grabPos;
	} 
}

if input_mouse_moved() || input_source_using(INPUT_MOUSE) {
	x = clamp(mouse_x,minCoordx,maxX);
	y = clamp(mouse_y,minCoordy,maxY);
	using_mk = true;	
} 
if input_check(["right","left","down","up","action"]) && input_source_using(INPUT_GAMEPAD) {
	if !instance_exists(obj_menu) {
		var moveX = (input_value("right") -input_value("left"))*delta_time*DELTA_TO_FRAMES,
		moveY = (input_value("down") -input_value("up"))*delta_time*DELTA_TO_FRAMES;
		x = clamp(x +moveX*global.cursor_sens,minCoordx,maxX);
		y = clamp(y +moveY*global.cursor_sens,minCoordy,maxY);
	}
	using_mk = false;
}
// Step Event of obj_cursor
tooltip_string = "";
tooltip_width = 0;
tooltip_height = 0;
tooltip_flip = 1; // 1 = left align, -1 = right align

// --- 1. Determine base cursor look ---
switch global.mode {
	case "delete":
		cursor_sprite = spr_cursor_delete;
		sprite_index = spr_cursor_delete;
	break;
	default:
		cursor_sprite = spr_cursor;
		sprite_index = spr_cursor;
	break;
}
if !using_mk && !instance_exists(obj_menu) {
    cursor_sprite = cr_none;
    image_alpha = 1;
} else {
	image_alpha = 0;
}

// Find hover target
var check = noone;
var movingSomething = noone;

// Scan obstacles
with obj_obstacle {
    var zOff = z;
	 var gridOff = piece_on_grid;
	if is_string(gridOff) {
		with obj_grid {
			if tag == gridOff {
				zOff += z;
				break;
			}
		}
	} else if instance_exists(gridOff) { zOff += gridOff.z; }

    if object_get_parent(object_index) == obj_generic_piece && execute == "move" && team == global.player_team {
        movingSomething = id;
    } else {
        if collision_rectangle(bbox_left, bbox_top - zOff, bbox_right, bbox_bottom - zOff, other, false, false) {
            other.tooltip_string = string(ceil(total_health(hp))) + " HP";
        }
        zOff -= z;
        if collision_rectangle(bbox_left, bbox_top - zOff, bbox_right, bbox_bottom - zOff, other, false, false) {
            check = id;
        }
    }
}
// Slot & passive popups
var slots = [obj_piece_slot, obj_loadout_slot, obj_unlocked_slot];
for (var i = 0; i < array_length(slots); i++) {
    var inst = instance_position(x, y, slots[i]);
    if instance_exists(inst) && inst.identity != "Empty" {
		tooltip_string = inst.desc;
    }
}
var passive = instance_position(x, y, obj_power_passive);
if instance_exists(passive) {
    tooltip_string = passive.desc;
}
// Moving piece logic
if instance_exists(movingSomething) {
    var zOff = movingSomething.z,
	invalid = false,
	brk = false;
	var gridRef = movingSomething.piece_on_grid;
	if is_string(gridRef) {
		with obj_grid {
			if tag == gridRef {
				gridRef = id;
				break;
			}
		}
	}
    if instance_exists(gridRef) zOff += gridRef.z;

    if !collision_rectangle(movingSomething.bbox_left, movingSomething.bbox_top - zOff,
                             movingSomething.bbox_right, movingSomething.bbox_bottom - zOff,
                             id, false, true) {
        if instance_exists(check) { 
			invalid = check.team == movingSomething.team; 
		}

        with movingSomething {
            var gcX = x, gcY = y;
            if instance_exists(gridRef) {
                gcX = grid_pos[0] * GRIDSPACE + gridRef.bbox_left;
                gcY = grid_pos[1] * GRIDSPACE + gridRef.bbox_top;
            }

            var mouseOn = false, mouseOnCantAttack = false;

            for (var set = 0; set < array_length(valid_moves); ++set) {
                for (var i = 0; i < array_length(valid_moves[set]); ++i) {
                    var dx = is_string(valid_moves[set][i][0]) ? tm_dp(real(valid_moves[set][i][0]), team, toggle) : valid_moves[set][i][0];
                    var dy = is_string(valid_moves[set][i][1]) ? tm_dp(real(valid_moves[set][i][1]), team, toggle) : valid_moves[set][i][1];

                    var xM = dx * GRIDSPACE + gcX;
                    var yM = dy * GRIDSPACE + gcY;
                    var zOff2 = 0;
                    var onGrid = instance_position(xM + GRIDSPACE/2, yM + GRIDSPACE/2, obj_grid);
                    if instance_exists(onGrid) zOff2 = onGrid.z;

                    if collision_rectangle(xM, yM - zOff2, xM + GRIDSPACE, yM + GRIDSPACE - zOff2, other, false, true) && (dx != 0 || dy != 0) {
                        mouseOn = true;
                        if set != BOTH && set != ONLY_ATTACK mouseOnCantAttack = true;
                        brk = true
						break;
                    }
                }
				if brk { break; }
            }

            if mouseOn {
               if invalid {
					other.tooltip_string = "ILLEGAL";	
				} else {
					if mouseOnCantAttack {
						other.tooltip_string = "MOVE";
					} else {
						if !instance_exists(check) {
							other.tooltip_string = string(attack_power) +" ATTACK";
						} else {
							// See if it can be killed
							var dummyHP = variable_clone(check.hp);
							hurt(dummyHP,attack_power,DAMAGE.PHYSICAL);
							if total_health(dummyHP) > 0 {
								other.tooltip_string = "CAN'T KILL"		
							} else {
								other.tooltip_string = "KILL"
							}
						}
					}				
				}
            }
        }
    }
}



// Cache dimensions
if tooltip_string != "" {
    draw_set_font(fnt_bit);
	tooltip_width  = string_width(tooltip_string);
    tooltip_height = string_height(tooltip_string);
    tooltip_flip   = (x <= (minCoordx +maxX)/2) ? 1 : -1;
}