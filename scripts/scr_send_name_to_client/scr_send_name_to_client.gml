function scr_send_name_to_client(){
	buffer_seek(buffer, buffer_seek_start, 0);
	buffer_write(buffer, buffer_u8, PACKET_NAME);
	buffer_write(buffer, buffer_string, argument1);

	
	network_send_packet(argument0, buffer, buffer_tell(buffer));
	
}