if !place_meeting(x,y,obj_conveyor_grid) && start {
	instance_create_layer(x,y,"Grid",obj_conveyor_grid,{
		speed_h: speed_h,
		speed_v: speed_v
	})
}