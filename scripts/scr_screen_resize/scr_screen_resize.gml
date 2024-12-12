function screen_resize(dispWidth,dispHeight,save_to_file = 1){
	global.screen_res[0] = dispWidth;
	global.screen_res[1] = dispHeight;
	display_set_gui_size(dispWidth,dispHeight);
	window_set_size(dispWidth,dispHeight);
	
	var aspect = 1280/720;
	
	if dispWidth >= dispHeight {
		var
		height = (dispHeight),
		width = aspect*height;
	}
	
	surface_resize(application_surface,width,height)
	
	if save_to_file {
		save(PROFILE);	
	}
}