var cursorMargin = GUI_MARGIN,
minCoord = 0 +cursorMargin,
maxX = room_width -cursorMargin,
maxY = room_height -cursorMargin;
on_grid = noone;
// With grid
with obj_grid {
	if collision_rectangle(bbox_left,bbox_top -z,bbox_right,bbox_bottom -z,obj_cursor,false,false) {
		other.on_grid = id;
		other.grid_pos[0] = floor((other.x -bbox_left)/GRIDSPACE);
		other.grid_pos[1] = floor((other.y -(bbox_top -z))/GRIDSPACE);
	} 
}


if input_mouse_moved() || input_source_using(INPUT_MOUSE) {
	x = clamp(mouse_x,minCoord,maxX);
	y = clamp(mouse_y,minCoord,maxY);
	using_mk = true;	
} 
if input_check(["right","left","down","up","action"]) && input_source_using(INPUT_GAMEPAD) {
	if !instance_exists(obj_menu) {
		var moveX = (input_value("right") -input_value("left"))*delta_time*DELTA_TO_FRAMES,
		moveY = (input_value("down") -input_value("up"))*delta_time*DELTA_TO_FRAMES;
		x = clamp(x +moveX*global.cursor_sens,minCoord,maxX);
		y = clamp(y +moveY*global.cursor_sens,minCoord,maxY);
	}
	using_mk = false;
}

