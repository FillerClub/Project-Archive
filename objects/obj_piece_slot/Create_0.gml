error_time = time_source_create(time_source_global,.03,time_source_units_seconds,function(){
	if draw_red_box == 0 {
		draw_red_box = 1;
	} else {
		draw_red_box = 0;
	}	
},[],6);

info = piece_database(identity);

sprite_slot = info[PIECEDATA.SLOTSPRITE];
cost = info[PIECEDATA.PLACECOST];
class = info[PIECEDATA.CLASS];
desc = info[PIECEDATA.BRIEFDESCRIPTION];
cooldown_length = info[PIECEDATA.SLOTCOOLDOWN];
cooldown = 0;