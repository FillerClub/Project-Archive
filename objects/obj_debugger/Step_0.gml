

if keyboard_check_pressed(vk_f2) {
	global.verbose_debug = !global.verbose_debug;	
}
if !global.debug {
	exit;	
}
if keyboard_check_pressed(vk_numpad0) {
	menu = -1;	
}


// Submenus
switch menu {
	case -1:
		if keyboard_check_pressed(vk_numpad1) {
			menu = DEBUG.GAME;	
		}
		if keyboard_check_pressed(vk_numpad2) {
			menu = DEBUG.ONLINE;	
		}
	break;
	case DEBUG.ONLINE:
	case DEBUG.ONLINESTATESCOMPARE:
		if keyboard_check_pressed(vk_numpad1) {
			menu = DEBUG.ONLINE;	
		}
		if keyboard_check_pressed(vk_numpad2) {
			menu = DEBUG.ONLINESTATESCOMPARE;	
		}		
	break;
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
