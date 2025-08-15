if time_source_get_state(error_time) == time_source_state_stopped {
	draw_blue_green = true;
}
if global.debug && position_meeting(obj_cursor.x,obj_cursor.y,self) && input_check_pressed("action") {
	ammo = 6;	
}
ammo = clamp(ammo,0,6);