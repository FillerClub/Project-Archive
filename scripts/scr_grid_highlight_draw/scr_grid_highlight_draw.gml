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
precheckX = x,
precheckY = y,
drawToX = x,
drawToY = y,
color = c_white,
checkPieceObject = object_index != obj_dummy,
drawnSquareIsMeeting = noone;
for (var moves = 0; moves < ar_leng; moves++) {
	color = c_white;
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
	if position_meeting(drawToX,drawToY,obj_grid) {
		onGrid = instance_position(drawToX,drawToY,obj_grid);
		drawToX = floor((drawToX -onGrid.bbox_left)/GRIDSPACE)*GRIDSPACE +onGrid.bbox_left;
		drawToY = floor((drawToY -onGrid.bbox_top)/GRIDSPACE)*GRIDSPACE +onGrid.bbox_top;	
		// Verify position is actually on grid
		if !position_meeting(drawToX +GRIDSPACE/2,drawToY +GRIDSPACE/2,onGrid) {
			continue;	
		}
		// Check if cursor is on a grid
		if position_meeting(obj_cursor.x,obj_cursor.y,obj_grid) {
			var 
			cursorOnGrid = instance_position(obj_cursor.x,obj_cursor.y,obj_grid),
			cursorX = floor((obj_cursor.x -cursorOnGrid.bbox_left)/GRIDSPACE)*GRIDSPACE +cursorOnGrid.bbox_left,
			cursorY = floor((obj_cursor.y -cursorOnGrid.bbox_top)/GRIDSPACE)*GRIDSPACE +cursorOnGrid.bbox_top; 
			// If the cursor's position is equal to the drawn square AND is not at the center of the piece/object
			if (cursorX == drawToX) && (cursorY == drawToY) && !(precheckX == 0 && precheckY == 0) {
				color = c_aqua;	
			}
		}
		// Check if square is on an object it can't colide with
		if position_meeting(drawToX,drawToY,obj_obstacle) {
			drawnSquareIsMeeting = instance_position(drawToX,drawToY,obj_obstacle);
			if (drawnSquareIsMeeting.hp <= 0) || (exclude_barriers && drawnSquareIsMeeting.object_index != obj_hero_wall) {
				color = c_red;
			}
		} else {
			drawnSquareIsMeeting = noone;	
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
							if drawnSquareIsMeeting.team != team {
								color = c_red;	
							}
						}						
					break;	
					case DIFFERENT:
						if drawnSquareIsMeeting != noone {
							if drawnSquareIsMeeting.team == team {
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
		if !faux {
			var draw_spr = spr_grid_highlight;	
		} else { var draw_spr = spr_grid_dotted; }
		draw_sprite_ext(draw_spr,image_index,
		drawToX,
		drawToY,
		1,1,0,color,1);		
		
		if show_lines {
			draw_line_width_color(x +sprite_width/2,y +sprite_height/2,drawToX +sprite_width/2,drawToY +sprite_height/2,2,c_white,color);
			draw_circle_color(x +sprite_width/2,y +sprite_height/2,3,c_white,c_white,0);
			draw_rectangle_color(drawToX +sprite_width/2-7,drawToY +sprite_height/2-7,drawToX +sprite_width/2+7,drawToY +sprite_height/2+7,color,color,color,color,0);			
		}
	} 
}	



/*
// Grab grid variables
var cursorInstance = obj_cursor,
cX = cursorInstance.x,
cY = cursorInstance.y,
onGrid = cursorInstance.on_grid,
pieceOnGrid = noone,
gridPos = cursorInstance.grid_pos,
gridX = -9999,
gridY = -9999,
pieceX = -9999,
pieceY = -9999,
newpieceX = pieceX,
newpieceY = pieceY,
col = c_red,
meetingObject = noone,
meetingObjHP = 0,
can_move = true,
// Grab amount of valid moves
ar_leng = array_length(valid_spots);
pieceX = floor((x -cursor_on_grid.bbox_left)/GRIDSPACE)*GRIDSPACE +cursor_on_grid.bbox_left;
pieceY = floor((y -cursor_on_grid.bbox_top)/GRIDSPACE)*GRIDSPACE +cursor_on_grid.bbox_top;
newpieceX = pieceX;
newpieceY = pieceY;
if onGrid != noone {
	gridX = gridPos[0]*GRIDSPACE +onGrid.bbox_left;
	gridY = gridPos[1]*GRIDSPACE +onGrid.bbox_top;	
}
// For each move available (i)
for (var i = 0; i < ar_leng; ++i)	{
	meetingObject = noone;
	var preValidX = valid_spots[i][0],
	preValidY = valid_spots[i][1];
	// Check if affected by team & toggle
	if is_string(preValidX) {
		preValidX = tm_dp(real(preValidX),team,toggle);
	}
	if is_string(preValidY) {
		preValidY = tm_dp(real(preValidY),team,toggle);
	}
	newpieceX = pieceX +preValidX*GRIDSPACE +GRIDSPACE/2;
	newpieceY = pieceY +preValidY*GRIDSPACE +GRIDSPACE/2;
	if position_meeting(newpieceX,newpieceY,obj_grid) {
		pieceOnGrid = instance_position(newpieceX,newpieceY,obj_grid);
	} else {
		pieceOnGrid = noone;	
	}
	// If coords within move array are on the grid; 0 = x, 1 = y
	if pieceOnGrid != noone || skip_grid_check {
		// If mouse happens to be on valid move (EXCEPT if valid move is [0,0], draw AQUA. Else WHITE
		if position_meeting(newpieceX,newpieceY,obj_obstacle) && pieceOnGrid != noone {
			meetingObject = instance_position(newpieceX,newpieceY,obj_obstacle);
			meetingObjHP = meetingObject.hp;
		}
		if (meetingObjHP <= 0 && meetingObject != noone) || (exclude_barriers && position_meeting(newpieceX,newpieceY,obj_hero_wall)) {
			col = c_red;
		} else {
		// Check how script respects grid territories
			switch placeable_on_grid {		
				case SAME:
					if pieceOnGrid.team == team {
						col = c_white;	
					}
				break;
			
				case NEUTRAL:
					if pieceOnGrid.team == team || pieceOnGrid.team == "neutral" {
						col = c_white;	
					}
				break;
			
				case PLACEABLENONE:
					col = c_red;
				break; 

			
				default:
					col = c_white;
				break;
			

			}
			switch placeable_on_piece {
					case SAME:
						if meetingObject != noone {
							if meetingObject.team == team {
								col = c_white;	
							} else {
								col = c_red;	
							}
						}						
					break;
			
					case DIFFERENT:
						if meetingObject != noone {
							if meetingObject.team != team {
								col = c_white;	
							} else {
								col = c_red;	
							}
						}
					break;
			
					case PLACEABLEANY:
						if meetingObject != noone {
							col = c_white;	
						}
					break;
			
					case PLACEABLENONE:
						if meetingObject != noone {
							col = c_red;	
						}
					break;
			}
		}
		if (gridX == newpieceX) && (gridY == newpieceY) && (valid_spots[i][0] != 0 || valid_spots[i][1] != 0) && col == c_white && !faux {
			col = c_aqua;
		} 
		// Draw valid moves on grid
		if !faux {
			var draw_spr = spr_grid_highlight;	
		} else { var draw_spr = spr_grid_dotted; }
		audio_stop_sound(snd_critical_error);
		audio_play_sound(snd_critical_error,0,0);
		draw_sprite_ext(draw_spr,image_index,
		gridX,
		gridY,
		1,1,0,col,1);
		}		
		
		if show_lines {
			draw_line_width_color(x +sprite_width/2,y +sprite_height/2,newpieceX +sprite_width/2,newpieceY +sprite_height/2,2,c_white,col);
			draw_circle_color(x +sprite_width/2,y +sprite_height/2,3,c_white,c_white,0);
			draw_rectangle_color(newpieceX +sprite_width/2-7,newpieceY +sprite_height/2-7,newpieceX +sprite_width/2+7,newpieceY +sprite_height/2+7,col,col,col,col,0);			
		}
		
	//draw_sprite_ext(spr_grid_highlight,0,x,y,1,1,0,c_white,1);
	}
	*/
}
