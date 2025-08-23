function steam_relay_message(Message) { // Sent From Client
	var Data = {Message : Message}
	var json = json_stringify(Data);
	var buff = buffer_create(string_byte_length(json), buffer_fixed, 1);
	buffer_write(buff, buffer_text, json);
	steam_net_packet_send(steam_lobby_get_owner_id(),buff);
	buffer_delete(buff);
	return;
}

function steam_relay_data(Buffer) { // Sent From Client
	var json = json_stringify(Buffer);
	var buff = buffer_create(string_byte_length(json), buffer_fixed, 1);
	buffer_write(buff, buffer_text, json);
	steam_net_packet_send(steam_lobby_get_owner_id(),buff);
	buffer_delete(buff);
	return;
}

function steam_bounce(Buffer) {
	var json = json_stringify(Buffer);
	var buff = buffer_create(string_byte_length(json), buffer_fixed, 1);
	buffer_write(buff, buffer_text, json);
	
	for(var i = 0; i < steam_lobby_get_member_count(); i++) {
		var MemberID = steam_lobby_get_member_id(i);
		steam_net_packet_send(MemberID,buff);
	}

	buffer_delete(buff);
	return;
}