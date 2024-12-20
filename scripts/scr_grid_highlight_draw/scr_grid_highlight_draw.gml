/// @description Draws on grid all valid moves provided, with extra functionality
/// @function scr_moving_piece_highlight_draw(valid_moves)
#macro SAME 0
#macro NEUTRAL 1
#macro PLACEABLEANY 2
#macro PLACEABLENONE 3

#macro DIFFERENT 1

function grid_highlight_draw(valid_spots = [[0,0]], placeable_on_grid = PLACEABLEANY, placeable_on_piece = DIFFERENT, exclude_barriers = false, skip_grid_check = false, faux = false, show_lines = false){
// Grab grid variables
var gS = global.grid_spacing,
gD = global.grid_dimensions,
gOffsetX = gD[0] mod gS,
gOffsetY = gD[2] mod gS,
gX = obj_cursor.x,
gY = obj_cursor.y,
gcX = floor(x/gS)*gS,
gcY = floor(y/gS)*gS,
col = c_red,
mosX = floor(gX/gS)*gS,
mosY = floor(gY/gS)*gS,
meeting = noone,
can_move = true;
// Grab amount of valid moves
var ar_leng = array_length(valid_spots);

// For each move available (i)
for (var i = 0; i < ar_leng; ++i)	{
	meeting = noone;
	var preValidX = valid_spots[i][0],
	preValidY = valid_spots[i][1];
	// Check if affected by team & toggle
	if is_string(preValidX) {
		preValidX = tm_dp(real(preValidX),team,toggle);
	}
	if is_string(preValidY) {
		preValidY = tm_dp(real(preValidY),team,toggle);
	}
	var xM = preValidX*gS +gcX;
	var yM = preValidY*gS +gcY;		
	// If coords within move array are on the grid; 0 = x, 1 = y
	if position_meeting(xM,yM,obj_grid) || skip_grid_check{
		// If mouse happens to be on valid move (EXCEPT if valid move is [0,0], draw AQUA. Else WHITE
		if position_meeting(xM,yM,obj_obstacle) {
			meeting = instance_position(xM,yM,obj_obstacle).hp;
		}
		if (meeting <= 0 && meeting != noone) || (exclude_barriers && position_meeting(xM,yM,obj_hero_wall)) {
			col = c_red;
		} else {
		// Check how script respects grid territories
			switch placeable_on_grid {
				case SAME:
					if (position_meeting(xM,yM,obj_territory_friendly) && team == "friendly") || (position_meeting(xM,yM,obj_territory_enemy) && team == "enemy") {
						col = c_white;	
					}
				break;
			
				case NEUTRAL:
					if !(position_meeting(xM,yM,obj_territory_enemy) && team == "friendly") && !(position_meeting(xM,yM,obj_territory_friendly) && team == "enemy") {
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
						if position_meeting(xM,yM,obj_obstacle) {
							var instattack = instance_position(xM,yM,obj_obstacle);
							if instattack.team == team {
								col = c_white;	
							} else {
								col = c_red;	
							}
						}						
					break;
			
					case DIFFERENT:
						if position_meeting(xM,yM,obj_obstacle) {
							var instattack = instance_position(xM,yM,obj_obstacle);
							if instattack.team != team {
								col = c_white;	
							} else {
								col = c_red;	
							}
						}
					break;
			
					case PLACEABLEANY:
						if position_meeting(xM,yM,obj_obstacle) {
							col = c_white;	
						}
					break;
			
					case PLACEABLENONE:
						if position_meeting(xM,yM,obj_obstacle) {
							col = c_red;	
						}
					break;
				
			}
		}
		if (mosX == xM) && (mosY == yM) && (valid_spots[i][0] != 0 || valid_spots[i][1] != 0) && col == c_white && !faux {
			col = c_aqua;
		} 
		// Draw valid moves on grid
		if !faux {
			var draw_spr = spr_grid_highlight;	
		} else { var draw_spr = spr_grid_dotted; }
		
		draw_sprite_ext(draw_spr,image_index,
		xM,
		yM,
		1,1,0,col,1);
		}		
		
		if show_lines {
			draw_line_width_color(x +sprite_width/2,y +sprite_height/2,xM +sprite_width/2,yM +sprite_height/2,2,c_white,col);
			draw_circle_color(x +sprite_width/2,y +sprite_height/2,3,c_white,c_white,0);
			draw_rectangle_color(xM +sprite_width/2-7,yM +sprite_height/2-7,xM +sprite_width/2+7,yM +sprite_height/2+7,col,col,col,col,0);			
		}
		
	//draw_sprite_ext(spr_grid_highlight,0,x,y,1,1,0,c_white,1);
	}
}
