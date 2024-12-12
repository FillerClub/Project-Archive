/// @desc Converts x,y in game world to gui x,y, credits to u/ThatOneLilVillager ig
/// @param {real} coord position in game world
/// @param {bool} is_y? by default assumes argument is x position
/// @returns {array<Real>} array contains x,y position in gui
function camera_to_gui(coord,vertical = false){
	var gui_coord = coord;
	
	if !vertical {
		var 
		cl = camera_get_view_x(view_camera[0]),
		off_x = argument0 - cl, // x is the normal x position
		off_x_percent = off_x / camera_get_view_width(view_camera[0]);
		gui_coord = off_x_percent * display_get_gui_width();
	} else {
		var 
		ct = camera_get_view_y(view_camera[0]),
		off_y = argument0 - ct, // y is the normal y position
		off_y_percent = off_y / camera_get_view_height(view_camera[0]);
		gui_coord = off_y_percent * display_get_gui_height();		
	}
	// convert to gui  
	return gui_coord;	
}