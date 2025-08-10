/// @desc Collect points
audio_stop_sound(snd_pick_up);
timer_tick(global.turn_increment);
resource_timer = 0;
time_to_produce = random_percent(12,10);