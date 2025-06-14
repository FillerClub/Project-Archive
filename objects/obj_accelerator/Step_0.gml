event_inherited();
if sprite_accel > 0 { sprite_accel -= delta_time*DELTA_TO_SECONDS/10; }
if global.game_state == PAUSED {
	exit;	
}

if resource_timer >= time_to_produce {
	image_index = min(image_index +1, 3);
	var checkNoExcess = ((team == "friendly")? (global.player_turns < global.max_turns):(global.opponent_turns < global.max_turns));
	if input_check_pressed("action") && position_meeting(obj_cursor.x,obj_cursor.y,self) && checkNoExcess {
		execute = "nothing";
		audio_stop_sound(snd_pick_up);
		timer_tick(1);
		resource_timer = 0;
		time_to_produce = random_percent(24,10);
	}
} else {
	image_index = max(image_index -1, 0);
	resource_timer += delta_time*DELTA_TO_SECONDS;	
}
