#macro MAIN 0
#macro LEVELSTART 0
#macro FINALWAVE 1
#macro VICTORY 2

graphic_show = LEVELSTART;

timer = time_source_create(time_source_game,7,time_source_units_seconds, function() {
	variable_timer[LEVELSTART] = 2.5;
	phase = 1;
},[],-1,time_source_expire_nearest);	

graphic_timer = time_source_create(time_source_global,2.5,time_source_units_seconds,function() {
	audio_play_sound(snd_critical_error,0,0);
	time_source_destroy(graphic_timer);
},[],1,time_source_expire_after);

time_source_start(timer);
time_source_start(graphic_timer);


//phase = 3;