function write_all_player_data(buffer,name,status,hero,loadout){
	write_data_buffer(buffer,REMOTEDATA.NAME,name);
	write_data_buffer(buffer,REMOTEDATA.STATUS,status);
	write_data_buffer(buffer,REMOTEDATA.HERO,hero);
	write_data_buffer(buffer,REMOTEDATA.LOADOUT,loadout);
}
function write_all_gamerule_data(buffer,max_slots,show_slots,barrier_condition,time_length,max_pieces){
	write_data_buffer(buffer,REMOTEDATA.MAXSLOTS,max_slots);
	write_data_buffer(buffer,REMOTEDATA.SHOWSLOTS,show_slots);
	write_data_buffer(buffer,REMOTEDATA.BARRIER,barrier_condition);
	write_data_buffer(buffer,REMOTEDATA.TIMELENGTH,time_length);		
	write_data_buffer(buffer,REMOTEDATA.MAXPIECES,max_pieces);		
}