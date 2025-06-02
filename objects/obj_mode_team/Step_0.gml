
if (input_check_pressed("action") && position_meeting(obj_cursor.x,obj_cursor.y,self)) {
	switch global.player_team {
		case "friendly":
		global.player_team = "enemy";
		global.opponent_team = "friendly";
		sprite = spr_enemy_team;
		image_speed = 1;
		image_index = 0;
		break;
		
		default:
		global.player_team = "friendly";
		global.opponent_team = "enemy";
		sprite = spr_friendly_team;
		image_speed = 1;
		image_index = 0;

		break;
	}
}	
