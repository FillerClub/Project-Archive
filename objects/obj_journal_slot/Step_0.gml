if mouse_pressed_on {
	var findIndex = 0,
	matchName = code;
	with obj_journal_index_manager {
		for (var i = 0; i < array_length(list); i++) {
			if list[i].code	== matchName {
				findIndex = i +1;
				break;	
			}
		}
	}
	with obj_journal {
		if index != findIndex {
			audio_stop_sound(snd_page_turn);
			audio_play_sound(snd_page_turn,0,0);	
			index = findIndex;
		}
	}
	
}

mouse_pressed_on = false;