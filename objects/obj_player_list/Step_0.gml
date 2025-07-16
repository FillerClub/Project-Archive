var inputV = input_check_pressed("up") -input_check_pressed("down"),
arLeng = array_length(player);
index -= inputV;


if index >= arLeng {
	index = 0;	
} else if index < 0 {
	index = arLeng -1;
}

if input_check_pressed("action") && arLeng > 0 && global.game_state == RUNNING {
	if status[index] == ONLINESTATUS.WAITING {
		var connectToPort = port[index];
		with obj_client_manager {
			if game_status == ONLINESTATUS.IDLE {
				game_status = ONLINESTATUS.PREPARING;
				member_status = MEMBERSTATUS.MEMBER;
				// Send connection request to server
				match_togglejoin(connectToPort);
				buffer_seek(send_buffer,buffer_seek_start,0);
				buffer_write(send_buffer,buffer_u8,SEND.MATCHDATA);
				write_data_buffer(send_buffer,DATA.STATUS,game_status);
				buffer_write(send_buffer,buffer_u8,DATA.END);
				network_send_udp(socket,server_ip,server_port,send_buffer,buffer_tell(send_buffer));	
			}
		}
		room_goto(rm_loadout_zone_multiplayer);
	}
}