var spriteKnob = spr_main_knob;
switch sprite_index {
	case spr_pause_slider:
		spriteKnob = spr_pause_knob;
	break;
	
	default:
	break;
}

linked_object = instance_create_layer(x,y,"GUI",obj_slider_knob, {
	left_bound: bbox_left,
	right_bound: bbox_right,
	purpose: purpose,
	sprite_index: spriteKnob,
});

