function handle_tutorials(tutorialProgress) {
	var executed = false;
	switch tutorialProgress {
		case 1:
			if !instance_exists(tutorial_piece) {
				executed = true;
				break;
			}
			
			if global.player_turns < tutorial_piece.cost {
				with obj_timer {
					if (timer >= seconds_per_turn) {
						timer = 0;	
						total_ticks += 1;
						click_time = seconds_per_turn / 16
						timer_tick();
					} else {
						timer += delta_time*DELTA_TO_SECONDS;	
					}
				}
			}

			with tutorial_piece {
				if moved == true {
					executed = true;
					ignore_pause = false;
					skip_timer = false;
				}
			}	
		break;
	}
	if executed {
		tutorial_piece = noone;
		if global.game_state == PAUSED global.game_state = RUNNING;
		save(SAVEFILE);
	}
}