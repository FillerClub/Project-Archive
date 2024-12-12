application_surface_draw_enable(false);
var vW = window_get_width();
var vH = window_get_height();

// Create ppfx system.
ppfx_id = new PPFX_System();
// Create profile with all effects.
var effects = new PPFX_Profile("Main", [

]);
// Load profile, so all effects will be used.
ppfx_id.ProfileLoad(effects);
