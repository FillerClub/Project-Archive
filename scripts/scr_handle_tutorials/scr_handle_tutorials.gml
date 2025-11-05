function handle_tutorials(tutorialProgress) {
	var executed = false;
	switch tutorialProgress {
		case 1:
			if !instance_exists(tutorial_piece) {
				executed = true;
				break;
			}
			
			if global.friendly_turns < tutorial_piece.cost {
				with obj_timer {
					if (timer >= seconds_per_turn) {
						timer = 0;	
						total_ticks += 1;
						click_time = seconds_per_turn / 8
						timer_tick();
					} else {
						timer += delta_time*DELTA_TO_SECONDS*global.level_speed;	
					}
				}
			}
			tutorial_piece.execute = "move"
				
			var requestAmt = array_length(requests);
			for (var r = 0; r < requestAmt; r++) {
				if requests[r].action_type != "Move" {
					if requests[r].action_type == "Delete" {
						array_delete(requests,r,1);
					}
					continue;
				}
				if requests[r].tag == tutorial_piece.tag {
					executed = true;
					with tutorial_piece {
						ignore_pause = false;
						uses_timer = true;	
					}
				}
			}
		break;
	}
	if executed {
		tutorial_piece = noone;
		if global.game_state == PAUSED global.game_state = RUNNING;
		save_file(SAVEFILE);
	}
}