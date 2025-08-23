event_inherited();

if global.game_state == PAUSED {
	exit;	
}

if resource_timer >= time_to_produce {
	image_index = min(image_index +1, 3);
	var checkNoExcess = ((team == "friendly")? (global.friendly_turns < global.max_turns):(global.enemy_turns < global.max_turns));
	var zOff = 0;
	if instance_exists(piece_on_grid) {
		zOff += piece_on_grid.z;	
	}
	if input_check_pressed("action") && collision_rectangle(bbox_left,bbox_top -zOff,bbox_right,bbox_bottom -zOff,obj_cursor,false,false) && checkNoExcess && team == global.player_team {
		var collect = {
			Message: SEND.GAMEDATA,
			action: "Interact",
			tag: tag,
		}
		with obj_battle_handler {
			array_push(requests,collect);
		}
	}
} else {
	image_index = max(image_index -1, 0);
	resource_timer += delta_time*DELTA_TO_SECONDS*global.level_speed;	
}
