// obj_lobby_controller - Step (Begin Step) Event
// Receive all network packets and process them

// Receive all network packets
while (steam_net_packet_receive()) {
    var packet_data = steam_net_packet_get_data();
    var sender_id = steam_net_packet_get_sender_id();

    try {
        var msg = json_parse(packet_data);
        msg.sender_id = sender_id;
        process_message(msg);
    } catch (e) {
        show_debug_message("Failed to parse packet: " + string(e));
    }
}

// Update host status (in case ownership transfers)
var was_host = is_host;
is_host = steam_lobby_is_owner();

if (was_host != is_host) {
    show_debug_message("Host status changed: " + string(is_host));
    if (is_host) {
        lobby_settings.sync_all_settings();
        player_roster.sync_roster();
    }
}

// Update member status
update_member_status();
