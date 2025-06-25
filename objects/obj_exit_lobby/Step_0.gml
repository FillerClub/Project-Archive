if position_meeting(obj_cursor.x,obj_cursor.y,self) && input_check_pressed("action") {
	instance_destroy(obj_client_manager);
	
	var lD = {
		run: "MainMenu",
		rm: rm_main_menu,
		load: [standalone_soundtracks]
	}
	start_transition(sq_circle_out,sq_circle_in,lD);	
}