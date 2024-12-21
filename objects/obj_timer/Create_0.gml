error_time = time_source_create(time_source_global,.03,time_source_units_seconds,function(){
	if draw_blue_green == 1 {
		draw_blue_green = 0;
	} else {
		draw_blue_green = 1;
	}	
},[],6);

click_time = ( seconds_per_turn / 16 );

if global.debug && room != rm_sandbox {
	instance_create_layer(x,y,"AboveBoard",obj_turn_operator, {
		team: team	
	})	
}
