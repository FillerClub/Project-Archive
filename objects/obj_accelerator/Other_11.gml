/// @desc Collect points
audio_stop_sound(snd_pick_up);
timer_tick(global.turn_increment);
timer -= timer_end;
timer_end = random_percent(12,10);
animation_change = false;
new_animation = sq_ira_idle;
