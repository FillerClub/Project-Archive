function scr_send_DESTROYaction_to_server(){
	buffer_seek(send_buffer, buffer_seek_start, 0);
	buffer_write(send_buffer, buffer_u8, MESSAGE_ACTION);
	buffer_write(send_buffer, buffer_u8, argument0); //MESSAGE ACTION
	buffer_write(send_buffer, buffer_bool, argument1); // isFriendly?
	buffer_write(send_buffer, buffer_s32, argument2); // X for creation
	buffer_write(send_buffer, buffer_s32, argument3); // Y for creation 


	
	network_send_raw(socket, send_buffer, buffer_tell(send_buffer));
}