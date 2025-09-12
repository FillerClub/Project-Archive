if !global.debug {
	exit;	
}
if keyboard_check_pressed(ord("3")) {
	online_menu = !online_menu;
}
if keyboard_check_pressed(ord("2")) {
	game_menu = !game_menu;
}
if keyboard_check_pressed(ord("1")) {
	show_all = !show_all;
	game_menu = show_all;
	online_menu = show_all;
}
// Force desync
if (keyboard_check_pressed(vk_f3)) {
    force_artificial_desync();
}
    
// Force rollback
if (keyboard_check_pressed(vk_f4)) {
    //force_rollback_test();
}
    
// Simulate network issues
if (keyboard_check_pressed(vk_f5)) {
    cycle_network_simulation();
}
    
// State dump
if (keyboard_check_pressed(vk_f6)) {
    show_detailed_state_comparison();
}
    
// Reset metrics
if (keyboard_check_pressed(vk_f7)) {
   // reset_debug_metrics();
}
    
// Chaos mode
if (keyboard_check_pressed(vk_f8)) {
    toggle_chaos_mode();
}

fps_catch_timer += delta_time*DELTA_TO_SECONDS;
catch_average_fps = (catch_average_fps*iterations +fps_real)/(iterations +1);
iterations++;
if fps_catch_timer >= .5 {
	display_fps = catch_average_fps;
	fps_catch_timer -= .5;
	catch_average_fps = 0;
	iterations = 1;
}
