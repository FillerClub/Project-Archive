// Draw post-processing in full screen
//gpu_set_alphatestenable(true);
main_id.DrawInFullscreen(application_surface);
main_id.DrawInFullscreen(global.grid_highlight_surface);
main_id.DrawInFullscreen(global.piece_surface);
main_id.DrawInFullscreen(global.gui_surface);
