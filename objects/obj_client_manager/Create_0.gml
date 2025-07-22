with obj_client_manager {
	if self != other {
		instance_destroy();	
	}
}
var connectIP = D_IP
if obj_game.debug_connection {
	connectIP = D_DEBUG_IP;
}
server_ip = connectIP;
server_port = D_PORT;
socket = network_create_socket_ext(network_socket_udp,D_PORT);
send_buffer = buffer_create(1024,buffer_fixed,1);
update_players = false;
game_status = -1;
member_status = -1;
players = [];

// Write a connection request
buffer_seek(send_buffer, buffer_seek_start,0);
buffer_write(send_buffer, buffer_u8,SEND.CONNECT); 
buffer_write(send_buffer, buffer_string,global.name); 
network_send_udp(socket,server_ip,server_port,send_buffer,buffer_tell(send_buffer));
