if time_source_get_state(error_time) == time_source_state_stopped {
	draw_blue_green = true;
}
ammo = clamp(ammo,0,6);