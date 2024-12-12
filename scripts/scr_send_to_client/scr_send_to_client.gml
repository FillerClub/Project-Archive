#macro CMD_ROOM 16
#macro CMD_CREATE 1

function scr_send_to_client(argument0,argument1,argument2){
	buffer_seek(buffer, buffer_seek_start, 0);
	buffer_write(buffer, buffer_u8, PACKET_COMMAND);
	buffer_write(buffer, buffer_u16, argument1);

	
	switch (argument1) {
		case CMD_ROOM:
			buffer_write(buffer, buffer_u16, argument2);
		break;
	}
	network_send_packet(argument0, buffer, buffer_tell(buffer));
}