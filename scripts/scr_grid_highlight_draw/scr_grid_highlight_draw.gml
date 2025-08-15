/// @description Draws on grid all valid moves provided, with extra functionality
/// @function scr_moving_piece_highlight_draw(valid_moves)
#macro SAME 0
#macro NEUTRAL 1
#macro PLACEABLEANY 2
#macro PLACEABLENONE 3
#macro DIFFERENT 1

function grid_highlight_draw(valid_spots = [[0,0]], placeable_on_grid = PLACEABLEANY, placeable_on_piece = DIFFERENT, exclude_barriers = true, skip_grid_check = false, faux = false, show_lines = false){
// Grab amount of valid moves
var ar_leng = array_length(valid_spots),
onGrid = noone,
cursorOnGrid = obj_cursor.on_grid,
cursorX = -9999,
cursorY = -9999,
precheckX = x,
precheckY = y,
drawToX = x,
drawToY = y,
color = c_white,
selectColor = c_white,
checkPieceObject = object_index != obj_dummy,
drawnSquareIsMeeting = noone,
healthDrawIteration = 0;
// Check if cursor is on a grid
var zOff = z;
if instance_exists(piece_on_grid) {
	zOff += piece_on_grid.z;		
}
for (var moves = 0; moves < ar_leng; moves++) {
	color = c_white;
	selectColor = c_white;
	drawnSquareIsMeeting = noone;
	precheckX = valid_spots[moves][0];
	precheckY = valid_spots[moves][1];
	// Check if affected by team & toggle
	if is_string(precheckX) {
		precheckX = tm_dp(real(precheckX),team,toggle);
	}
	if is_string(precheckY) {
		precheckY = tm_dp(real(precheckY),team,toggle);
	}
	//draw_text(x,y+80 +16*moves,string(precheckX) +" : "+string(precheckY));
	// Center coordinates if is drawing from piece
	drawToX = x +(precheckX +checkPieceObject/2)*GRIDSPACE;
	drawToY = y +(precheckY +checkPieceObject/2)*GRIDSPACE;
	//part_particles_burst(global.part_sys,drawToX,drawToY,part_slap);	
	// Snap to grid if it is on one
	onGrid = instance_position(drawToX,drawToY,obj_grid);
	if instance_exists(onGrid) {
		drawToX = floor((drawToX -onGrid.bbox_left)/GRIDSPACE)*GRIDSPACE +onGrid.bbox_left;
		drawToY = floor((drawToY -onGrid.bbox_top)/GRIDSPACE)*GRIDSPACE +onGrid.bbox_top;	
		// Verify position is actually on grid
		if !position_meeting(drawToX +GRIDSPACE/2,drawToY +GRIDSPACE/2,onGrid) {
			continue;	
		}
		// If the cursor's position is equal to the drawn square AND is not at the center of the piece/object
		if collision_rectangle(drawToX,drawToY -onGrid.z,drawToX +GRIDSPACE,drawToY +GRIDSPACE -onGrid.z,obj_cursor,false,true) && !(precheckX == 0 && precheckY == 0) {
			color = c_aqua;	
			selectColor = c_aqua;
		} 
		// Check if square is on an object it can't colide with
		if position_meeting(drawToX,drawToY,obj_obstacle) {
			drawnSquareIsMeeting = instance_position(drawToX,drawToY,obj_obstacle);
			if (total_health(drawnSquareIsMeeting.hp) <= 0) || (exclude_barriers && drawnSquareIsMeeting.object_index != obj_hero_wall) {
				color = c_red;
			}
		} else {
			drawnSquareIsMeeting = noone;
			if max(onGrid.z -zOff,0) > climb_height || max(zOff -onGrid.z,0) > drop_height {
				color = c_red;
			}
		}
		if color != c_red {
		// Check how script respects grid territories
			switch placeable_on_grid {		
				case SAME:
					if onGrid.team != team {
						color = c_red;	
					}
				break;
				case NEUTRAL:
					if onGrid.team != team && onGrid.team != "neutral" {
						color = c_red;	
					}
				break;
				case PLACEABLENONE:
					color = c_red;
				break;
			}
			switch placeable_on_piece {
					case SAME:
						if drawnSquareIsMeeting != noone {
							if drawnSquareIsMeeting.team == team {
								color = selectColor;	
							} else {
								color = c_red;	
							}
						}						
					break;	
					case DIFFERENT:
						if drawnSquareIsMeeting != noone {
							if drawnSquareIsMeeting.team != team {
								color = selectColor;
								if variable_instance_exists(self,"attack_power") {
									var atk = attack_power,
									hurtHP = variable_clone(drawnSquareIsMeeting.hp);
									hurt(hurtHP,atk,DAMAGE.PHYSICAL);
									if total_health(hurtHP) > 0 && selectColor != c_aqua {
										color = c_yellow;	
									} 
									with obj_piece_ui_manager {
										piece_attacking_array[healthDrawIteration] = drawnSquareIsMeeting;
										attack_power_array[healthDrawIteration] = atk;
									}
									healthDrawIteration++;
								}
							} else {
								color = c_red;	
							}
						}
					break;		
					case PLACEABLENONE:
						if drawnSquareIsMeeting != noone {
							color = c_red;	
						}
					break;
			}
		}
		
		// Draw valid moves on grid
		if !faux { var draw_spr = spr_grid_highlight;	
		} else { var draw_spr = spr_grid_dotted; }
		draw_sprite_ext(draw_spr,obj_piece_move_highlighter.image_index,
		drawToX,
		drawToY -onGrid.z,
		1,1,0,color,1);		
		if show_lines {
			draw_line_width_color(x +sprite_width/2,y +sprite_height/2 -zOff,drawToX +sprite_width/2,drawToY +sprite_height/2 -onGrid.z,2,c_white,color);
			draw_circle_color(x +sprite_width/2,y +sprite_height/2 -zOff,3,c_white,c_white,0);
			draw_rectangle_color(drawToX +sprite_width/2-7,drawToY +sprite_height/2-7 -onGrid.z,drawToX +sprite_width/2+7,drawToY +sprite_height/2+7 -onGrid.z,color,color,color,color,0);			
		}
	} 
}	
}
