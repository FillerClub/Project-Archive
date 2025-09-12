if !place_meeting(x,y,obj_conveyor_grid) && start {
	with instance_create_layer(x,y,"Grid",obj_conveyor_grid,{
		speed_h: speed_h,
		speed_v: speed_v
	}) {
		if instance_exists(obj_client_manager) {
			tag = array_shift(object_tag_list);	
		}	
	}
}