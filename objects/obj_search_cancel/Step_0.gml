if mouse_pressed_on {
    var forceUpdate = noone;
	with link_to {
		text = "";
		forceUpdate = send_text_to;
	}
	with forceUpdate {
		text_input = "";
		update = true;
	}
}
mouse_pressed_on = false;