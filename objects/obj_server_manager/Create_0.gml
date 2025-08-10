running_matches = 0;
match_index = 0;
oX = x;
exit_timer = 0;


socket = network_create_server(network_socket_udp,D_SERVER_PORT,32);
send_buffer = buffer_create(1024,buffer_fixed,1);
players = [];
update_players = false;