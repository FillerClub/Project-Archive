running_matches = 0;
match_index = 0;
oX = x;
exit_timer = 0;


socket = network_create_socket_ext(network_socket_udp,D_PORT);
send_buffer = buffer_create(1024,buffer_fixed,1);
players = [];
update_players = false;