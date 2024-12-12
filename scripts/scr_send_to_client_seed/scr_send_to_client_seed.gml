#macro PACKET_SEED 8

function scr_send_to_client_seed(argument0,argument1){
	buffer_seek(buffer, buffer_seek_start, 0);
	buffer_write(buffer, buffer_u8, PACKET_SEED);
	buffer_write(buffer, buffer_s32, argument1);

	network_send_packet(argument0, buffer, buffer_tell(buffer));
}