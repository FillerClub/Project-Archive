debug_connection = debug_connection?false:true;
create_system_message([string(debug_connection)]);

var connectIP = D_IP
if debug_connection {
	connectIP = D_DEBUG_IP;
}
server_ip = connectIP;