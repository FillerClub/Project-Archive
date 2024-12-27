application_surface_draw_enable(false);
gpu_set_alphatestenable(true);

global.grid_highlight_surface = -1;
global.piece_surface = -2;
global.gui_surface = -3;

global.grid_highlight_surface = make_surface_safe(global.grid_highlight_surface);
global.piece_surface = make_surface_safe(global.piece_surface);
global.gui_surface = make_surface_safe(global.gui_surface);

var vW = window_get_width();
var vH = window_get_height();

// Create main effects system.
main_id = new PPFX_System();
// Create profile with all effects.
var Meffects = new PPFX_Profile("Main", [

]);
main_id.ProfileLoad(Meffects);

// Set window
screen_resize(global.screen_res[0],global.screen_res[1],0);
window_set_fullscreen(global.fullscreen);

//Set FPS
game_set_speed(global.fps_target,gamespeed_fps);