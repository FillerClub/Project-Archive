function scr_client_connect(){
	var 
	ip = argument0,
	port = argument1;
	
	socket = network_create_socket(network_socket_tcp)
	
	network_set_config(network_config_connect_timeout, 15000);
	
	var connect = network_connect_raw(socket, ip , port)
	
	send_buffer = buffer_create(16384, buffer_fixed,1);
	
	clientmap = ds_map_create();
	
	if connect >= 0 {
		buffer_seek(send_buffer, buffer_seek_start, 0);
		buffer_write(send_buffer, buffer_u8, MESSAGE_JOIN);
		scr_alert_text("Successfully connected to server");
		//buffer_write(send_buffer, buffer_u16, );
		
		network_send_raw(socket, send_buffer, buffer_tell(send_buffer));
		
	} else {
		scr_alert_text("Couldn't connect to server.");
		instance_destroy();
	}
			
	return connect;
}