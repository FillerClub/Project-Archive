function write_all_player_data(buffer,name,status,hero,loadout){
	write_data_buffer(buffer,REMOTEDATA.NAME,name);
	write_data_buffer(buffer,REMOTEDATA.STATUS,status);
	write_data_buffer(buffer,REMOTEDATA.HERO,hero);
	write_data_buffer(buffer,REMOTEDATA.LOADOUT,loadout);
}