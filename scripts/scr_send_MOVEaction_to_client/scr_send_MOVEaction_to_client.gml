function scr_send_MOVEaction_to_client(){
	buffer_seek(buffer, buffer_seek_start, 0);
	buffer_write(buffer, buffer_u8, PACKET_ACTION_CLIENT);
	buffer_write(buffer, buffer_u8, argument1);
	buffer_write(buffer, buffer_s32, argument2);
	buffer_write(buffer, buffer_s32, argument3);
	buffer_write(buffer, buffer_u8, argument4);
	buffer_write(buffer, buffer_s32, argument5);
	buffer_write(buffer, buffer_s32, argument6);
	
	network_send_packet(argument0, buffer, buffer_tell(buffer));
	
}