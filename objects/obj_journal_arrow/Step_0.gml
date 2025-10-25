if mouse_on {
	repeat_timer += delta_time*DELTA_TO_SECONDS; 
} else {
	repeat_timer = 0;	
}
var timerCondition = repeat_timer >= .5
if mouse_pressed_on || timerCondition {
	if timerCondition {
		repeat_timer -= .25;	
	}
	if instance_exists(journal_link) && instance_exists(journal_index_link) {
		var arLeng = array_length(journal_index_link.list);
		if right && journal_link.index < arLeng {
			audio_stop_sound(snd_page_turn);
			audio_play_sound(snd_page_turn,0,0);
			journal_link.index++;
			journal_link.update = true;		
		} else if !right && journal_link.index > 0 {
			audio_stop_sound(snd_page_turn);
			audio_play_sound(snd_page_turn,0,0);				
			journal_link.index--;
			journal_link.update = true;		
		}		
	}
}
mouse_pressed_on = false;
mouse_on = false;
