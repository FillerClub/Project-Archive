error_time = time_source_create(time_source_global,.03,time_source_units_seconds,function(){
	if draw_blue_green == 1 {
		draw_blue_green = 0;
	} else {
		draw_blue_green = 1;
	}	
},[],10);