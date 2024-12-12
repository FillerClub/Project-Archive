click_time = ( seconds_per_turn / 16 );

if global.debug && room != rm_sandbox {
	instance_create_layer(x,y,"AboveBoard",obj_turn_operator, {
		team: team	
	})	
}
