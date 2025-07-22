audio_stop_all();
game_set_speed(60,gamespeed_fps);

with all {
	switch object_index {
		case input_controller_object:
		case obj_visual_handler:
		case obj_match_switcher:
		case obj_server_manager:
		case obj_debug_background:
		case obj_back_to_lobby:
		case obj_cursor:
		case obj_plain_text_box:
		case obj_game:
			// Ignore
		break;
		default:
			instance_destroy();
		break;
	}
}
