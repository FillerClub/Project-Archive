function display_draw(valid_spots = [[0,0]], draw_color, show_lines = false){
// Grab grid variables
var
gcX = floor(x/GRIDSPACE)*GRIDSPACE,
gcY = floor(y/GRIDSPACE)*GRIDSPACE,
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
	var xM = preValidX*GRIDSPACE +gcX;
	var yM = preValidY*GRIDSPACE +gcY;		
	if !position_meeting(xM,yM,obj_grid) {
		continue;	
	}
	draw_sprite_ext(spr_grid_highlight,image_index,
	xM,
	yM -z,
	1,1,0,draw_color,1);	
		
	if show_lines {
		draw_line_width_color(x +sprite_width/2,y +sprite_height/2 -z,xM +sprite_width/2,yM +sprite_height/2,2,c_white,draw_color);
		draw_circle_color(x +sprite_width/2,y +sprite_height/2 -z,3,c_white,c_white,0);
		draw_rectangle_color(xM +sprite_width/2-7,yM +sprite_height/2-7 -z,xM +sprite_width/2+7,yM +sprite_height/2+7,draw_color,draw_color,draw_color,draw_color,0);			
	}
}
}
