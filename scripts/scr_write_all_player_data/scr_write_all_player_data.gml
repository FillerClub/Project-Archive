function write_all_player_data(buffer,name,status,hero,loadout = ""){
	write_data_buffer(buffer,DATA.NAME,name);
	write_data_buffer(buffer,DATA.STATUS,status);
	write_data_buffer(buffer,DATA.HERO,hero);
	if loadout != "" {
		write_data_buffer(buffer,DATA.LOADOUT,loadout);
	}
}
function write_all_gamerule_data(buffer,max_slots,show_slots,barrier_condition,time_length,max_pieces,map){
	write_data_buffer(buffer,DATA.MAXSLOTS,max_slots);
	write_data_buffer(buffer,DATA.SHOWSLOTS,show_slots);
	write_data_buffer(buffer,DATA.BARRIER,barrier_condition);
	write_data_buffer(buffer,DATA.TIMELENGTH,time_length);		
	write_data_buffer(buffer,DATA.MAXPIECES,max_pieces);		
	write_data_buffer(buffer,DATA.MAP,map);		
}