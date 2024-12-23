application_surface_draw_enable(false);
gpu_set_alphatestenable(true);

global.grid_highlight_surface = -1;
global.piece_surface = -2;

var vW = window_get_width();
var vH = window_get_height();
// Create main effects system.
main_id = new PPFX_System();
// Create profile with all effects.
var Meffects = new PPFX_Profile("Main", [

]);
main_id.ProfileLoad(Meffects);
