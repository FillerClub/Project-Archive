var paused = obj_game.on_pause_menu;
if paused {
	y_spd = delta_time*DELTA_TO_FRAMES*(y_init -y)/arbitrary_limit;
} else {
	y_spd = delta_time*DELTA_TO_FRAMES*(y_init +arbitrary_limit-y)/arbitrary_limit;
}            
y_spd = y_spd*50 +sign(y_spd);

y = clamp(y +y_spd,y_init, y_init+arbitrary_limit);

if y <= y_init {
	pause_toggle = true;
} else {
	pause_toggle = false;	
}

if y >= y_init +arbitrary_limit {
	image_alpha = 0;	
} else {
	image_alpha = 1;	
}

if pause_toggle && !instance_exists(obj_menu) {
	create_menu(FIRSTPAUSE,PAUSE,x -120,y+264,32,20, 5,fnt_phone,fa_left,fa_middle);
} 
if !pause_toggle && instance_exists(obj_menu) && room != rm_main_menu {
	with obj_menu {
		if context == PAUSE {
			instance_destroy();	
		}
	}
}