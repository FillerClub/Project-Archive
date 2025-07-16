if global.game_state == PAUSED {
	exit;	
}

if resource_timer >= time_to_produce {
	image_index = min(image_index +1, 3);
	var checkNoExcess = ((team == "friendly")? (global.friendly_turns < global.max_turns):(global.enemy_turns < global.max_turns));
	if input_check_pressed("action") && position_meeting(obj_cursor.x,obj_cursor.y,self) && checkNoExcess && team == global.player_team {
		var move = {
			action: DATA.INTERACT,
			tag: tag,
		}
		with obj_battle_handler {
			array_push(requests,move);
		}
	}
	if interact {
		audio_stop_sound(snd_pick_up);
		timer_tick(global.turn_increment/2);
		resource_timer = 0;
		time_to_produce = random_percent(12,10);
		interact = false;
	}
} else {
	image_index = max(image_index -1, 0);
	resource_timer += delta_time*DELTA_TO_SECONDS*global.level_speed;	
}
