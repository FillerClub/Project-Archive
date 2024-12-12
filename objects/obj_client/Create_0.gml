randomize();


connect = scr_client_connect("100.74.138.66", PORT);
scr_online_setup();
global.socket = socket;

//network_connect(socket, "192.168.1.254", PORT);


/*if !instance_exists(obj_server) {
	scr_send_NAME_to_server(global.name);
}
