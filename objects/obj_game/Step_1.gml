if input_check_pressed("pause") {
	pause_game(on_pause_menu);	
}
	
var aL = false,
gS = GRIDSPACE,
mosX = floor(obj_cursor.x/gS)*gS,
mosY = floor(obj_cursor.y/gS)*gS;

//Debug functions
if global.debug {
	if input_check_pressed("special") {
		with instance_position(obj_cursor.x,obj_cursor.y,obj_piece_slot) {
			switch object_index {
				case obj_piece_slot:
					cooldown = 0;
				break;
				case obj_power_slot:
					cooldown = 0;
				break;
			}
		}
		with instance_position(obj_cursor.x,obj_cursor.y,obj_generic_piece) {
			switch identity {
				default:
					move_cooldown_timer = 0; 
				break;
			}
		}
	}
}