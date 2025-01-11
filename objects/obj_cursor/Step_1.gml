var cursorMargin = 32,
minCoord = 0 +cursorMargin,
maxX = room_width -cursorMargin,
maxY = room_height -cursorMargin;

// With grid
if instance_exists(obj_grid) {
	var gD = global.grid_dimensions;
	grid_pos[0] = floor((x -gD[0])/GRIDSPACE);
	grid_pos[1] = floor((y -gD[2])/GRIDSPACE);
}

if input_mouse_moved() || input_source_using(INPUT_MOUSE) {
	x = clamp(mouse_x,minCoord,maxX);
	y = clamp(mouse_y,minCoord,maxY);
	using_mk = true;	
	
} 
if input_check(["right","left","down","up"]) && input_source_using(INPUT_GAMEPAD) {
	if !instance_exists(obj_menu) {
		var moveX = (input_value("right") -input_value("left"))*delta_time*DELTA_TO_FRAMES,
		moveY = (input_value("down") -input_value("up"))*delta_time*DELTA_TO_FRAMES;
		x = clamp(x +moveX*global.cursor_sens,minCoord,maxX);
		y = clamp(y +moveY*global.cursor_sens,minCoord,maxY);
	}
	using_mk = false;
}

