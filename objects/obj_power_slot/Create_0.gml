// Wait for heros to be created
alarm[0] = 1;
error_time = time_source_create(time_source_global,.03,time_source_units_seconds,function(){
	if draw_red_box == 0 {
		draw_red_box = 1;
	} else {
		draw_red_box = 0;
	}	
},[],6);
var info = power_database("null");
cost = info[POWERDATA.COST];
cooldown_length = info[POWERDATA.COST];
sprite_slot = info[POWERDATA.SLOTSPRITE];
desc = info[POWERDATA.DESCRIPTION];