with obj_client_manager {
	if self != other {
		instance_destroy();	
	}
}
var connectIP = D_IP
if debug_connection {
	connectIP = D_DEBUG_IP;
}
server_ip = connectIP;
server_port = D_SERVER_PORT;
socket = network_create_socket_ext(network_socket_udp,D_CLIENT_PORT);
send_buffer = buffer_create(1024,buffer_fixed,1);
update_players = false;
game_status = -1;
member_status = -1;
players = [];

alarm[0] = 1;