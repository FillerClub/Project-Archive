
if (input_check_pressed("action") && position_meeting(obj_cursor.x,obj_cursor.y,self)) || input_check_pressed("start_delete") {
	switch global.mode {
		case "move":
		global.mode = "delete";
		with obj_generic_piece {
			if team == global.player_team && execute == "move" && obj_battle_handler.tutorial_piece != self {
				execute = "nothing";
			}
		}
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
