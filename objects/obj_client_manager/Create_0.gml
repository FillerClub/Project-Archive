with obj_client_manager {
	if self != other {
		instance_destroy();	
	}
}
server_ip = D_IP;
server_port = D_PORT;
socket = network_create_socket(network_socket_udp);
send_buffer = buffer_create(1024,buffer_fixed,1);
game_status = ONLINESTATUS.IDLE;
players = [];
// Write a connection request
buffer_seek(send_buffer, buffer_seek_start,0);
buffer_write(send_buffer, buffer_u8,SEND.CONNECT); 
buffer_write(send_buffer, buffer_string,global.name); 
network_send_udp(socket,server_ip,server_port,send_buffer,buffer_tell(send_buffer));
