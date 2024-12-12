
if (input_check_pressed("action") && position_meeting(obj_cursor.x,obj_cursor.y,self)) {
	switch global.team {
		case "friendly":
		global.team = "enemy";
		global.enemy_team = "friendly";
		sprite = spr_enemy_team;
		image_speed = 1;
		image_index = 0;
		break;
		
		default:
		global.team = "friendly";
		global.enemy_team = "enemy";
		sprite = spr_friendly_team;
		image_speed = 1;
		image_index = 0;

		break;
	}
}	
