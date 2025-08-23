if position_meeting(obj_cursor.x,obj_cursor.y,self) && input_check_pressed("action") {
	with obj_loadout_slot {
		x += room_width;
		locked = false;
	}	
	camera_set_view_pos(view_camera[0],room_width,0);
}
