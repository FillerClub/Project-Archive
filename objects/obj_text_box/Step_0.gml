if priority != 0 {
	exit;	
} else {
	typist.unpause();	
}

var smoothing = lerp(10,.2,lerp_var);
lerp_var = clamp(lerp_var +delta_time*DELTA_TO_SECONDS*smoothing,0,1);

var type_state = self.typist.get_state();

if type_state >= 1 {
	scale_sin += delta_time*DELTA_TO_SECONDS*4;
	scale = .9 + (sin(scale_sin) -.5)/8;
} else {
	if input_check_pressed("cancel") {
		typist.skip();
	}
}

if type_state >= 1 && input_check_pressed("action") {
	text_index++;
	if text_index < array_length(text) {
		typist.reset();
		scale_sin = 0;
		scale = .9;
	} else {
		with obj_text_box {
			priority--;	
		}
		instance_destroy();	
	}
}