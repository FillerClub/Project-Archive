
if keyboard_check_pressed(vk_anykey) || mouse_check_button_pressed(mb_any) {
	if image_alpha >= 1 {
		add_alpha = false;	
	}
}

timer += delta_time*DELTA_TO_SECONDS;

if timer >= .12 {
	timer = 0;
	if image_alpha < 1 && add_alpha == true {
		image_alpha += .1;	
	}
	if image_alpha > 0 && add_alpha == false {
		image_alpha -= .1;	
	} else {
		if image_alpha <= 0 && add_alpha == false {
			timer = -.6;
			add_alpha = true;
		}
	}
}
