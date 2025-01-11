application_surface_draw_enable(false);

// Create main effects system.
main_id = new PPFX_System();
// Create profile with all effects.
var Meffects = new PPFX_Profile("Main", [

]);
main_id.ProfileLoad(Meffects);

//Set FPS
game_set_speed(global.fps_target,gamespeed_fps);
screen_resize(global.screen_res[0],global.screen_res[1],0);
window_set_fullscreen(global.fullscreen);
