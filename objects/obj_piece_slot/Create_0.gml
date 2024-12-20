error_time = time_source_create(time_source_global,.03,time_source_units_seconds,function(){
	if draw_red_box == 0 {
		draw_red_box = 1;
	} else {
		draw_red_box = 0;
	}	
},[],10);

info = refer_database(identity);

sprite_slot = info[SLOTSPRITE];
cost = info[PLACECOST];
class = info[CLASS];
cooldown_length = info[SLOTCOOLDOWN];
cooldown = cooldown_length;