function make_surface_safe(surface, width = window_get_width(), height = window_get_height(), type = surface_rgba16float) {
if surface_exists(surface) {
	return surface;
}
return surface_create(width,height,type);
}