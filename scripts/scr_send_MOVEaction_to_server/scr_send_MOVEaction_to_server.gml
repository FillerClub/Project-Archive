function scr_send_MOVEaction_to_server(){
	buffer_seek(send_buffer, buffer_seek_start, 0);
	buffer_write(send_buffer, buffer_u8, MESSAGE_ACTION);
	buffer_write(send_buffer, buffer_u8, argument0);
	buffer_write(send_buffer, buffer_bool, argument1);
	buffer_write(send_buffer, buffer_s32, argument2);
	buffer_write(send_buffer, buffer_s32, argument3); 
	buffer_write(send_buffer, buffer_s32, argument4);
	buffer_write(send_buffer, buffer_s32, argument5);
	
	network_send_raw(socket, send_buffer, buffer_tell(send_buffer));
	
}