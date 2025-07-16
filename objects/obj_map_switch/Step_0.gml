if obj_ready.ready || obj_client_manager.member_status != MEMBERSTATUS.HOST {
	exit;	
}
var curX = obj_cursor.x,
sendUpdate = false,
increment = 0;
if position_meeting(curX,obj_cursor.y,self) {
	if input_check_pressed("action") {
		sendUpdate = true;
		if curX < x +sprite_width/2 {
			increment = -1;	
		} else {
			increment = 1;
		}
		map = clamp(map +increment,1,4);
	}
	if mouse_check_button_pressed(mb_middle) {
		sendUpdate = true;
		map = 1;
	}
	if sendUpdate {
		with obj_client_manager {
			buffer_seek(send_buffer,buffer_seek_start,0);
			buffer_write(send_buffer,buffer_u8,SEND.MATCHDATA);
			write_data_buffer(send_buffer,DATA.MAP,other.map);
			buffer_write(send_buffer,buffer_u8,DATA.END);
			network_send_udp(socket,server_ip,server_port,send_buffer,buffer_tell(send_buffer));	
		}
	}
}
