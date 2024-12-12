// intialize connection
#macro PORT 1987
#macro MAX_CLIENTS 2

// Packets
#macro PACKET_KEY 0
#macro PACKET_COMMAND 1
#macro PACKET_ACTION 2
#macro PACKET_ENTITY 3
#macro PACKET_ACTION_CLIENT 4
#macro PACKET_NAME 5



server = network_create_server(network_socket_tcp, PORT, MAX_CLIENTS);
buffer = buffer_create(16384, buffer_grow, 1);

clients = ds_map_create();
sockets = ds_list_create();



scr_online_setup();