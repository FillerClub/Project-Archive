
if (input_check_pressed("action") && position_meeting(obj_cursor.x,obj_cursor.y,self)) || input_check_pressed("alternate") {
	switch global.mode {
		case "move":
		global.mode = "delete";
		sprite = spr_mode_delete;
		image_speed = 1;
		image_index = 0;
		break;
		
		default:
		global.mode = "move";
		sprite = spr_mode_move;
		image_speed = 1;
		image_index = 0;

		break;
	}
}	
