function clear_surface_buffer(surface) {
surface_set_target(surface);
draw_clear_alpha(c_black,0);
surface_reset_target();
}