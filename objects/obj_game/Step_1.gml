if input_check_pressed("pause") {
	pause_game(on_pause_menu);	
}

if keyboard_check_pressed(vk_control) {
	create_system_message([string(asset_get_index(obj_grid))]);	
}