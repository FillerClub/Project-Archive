
expire += delta_time*DELTA_TO_SECONDS/2;
if expire >= 4.5 {
	if online {
		with obj_client_manager {
			game_status = ONLINESTATUS.PREPARING;
			buffer_seek(send_buffer,buffer_seek_start,0);
			buffer_write(send_buffer,buffer_u8,SEND.MATCHDATA);
			write_data_buffer(game_status,DATA.STATUS,game_status);
			buffer_write(send_buffer,buffer_u8,DATA.END);
			network_send_udp(socket,server_ip,server_port,send_buffer,buffer_tell(send_buffer));		
		}
		room_goto(rm_loadout_zone_multiplayer);	
	} else {
		room_goto(rm_main_menu);	
	}
	instance_destroy();
}