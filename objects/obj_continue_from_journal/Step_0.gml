if mouse_pressed_on {
	var lD = {
		run: "Lvl",
		rm: rm_world_one,
		load: [track1,track2,track3,track4,standalone_soundtracks]
	};
	start_transition(sq_circle_out,sq_circle_in,lD);	
}

mouse_on = false;
mouse_pressed_on = false;